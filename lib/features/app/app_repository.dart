import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/core/utils/logger.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:duegas/features/app/model/reward_history_model.dart';
import 'package:duegas/features/app/model/sales_model.dart';
import 'package:duegas/features/auth/model/customer_model.dart';

class AppRepository {
  final FirebaseFirestore firestore;

  AppRepository({required this.firestore});

  Stream<GasBalanceModel> getGasBalance() {
    return FirebaseFirestore.instance
        .collection('GasBalance')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      final doc = snapshot.docs.first;
      logger.d(doc.data());

      return GasBalanceModel.fromJson(doc.data(), id: doc.id);
    });
  }

  Future<void> saveGasBalance(GasBalanceModel balance, {String? docId}) async {
    if (docId != null) {
      await firestore
          .collection('GasBalance')
          .doc(docId)
          .update(balance.toJson());
    } else {
      await firestore.collection('GasBalance').add(balance.toJson());
    }
  }

  Future<void> makeSale(GasBalanceModel balance, SalesModel sales) async {
    double remainingKg = (balance.quantityKg! - sales.quantityInKg!);
    double remainingPrice = (balance.totalPrice! - sales.priceInNaira!);
    Map<String, dynamic> gasBalanceUpdate = {
      'quantityKg': remainingKg,
      'totalPrice': remainingPrice
    };
    await firestore
        .collection('GasBalance')
        .doc(balance.id)
        .update(gasBalanceUpdate);
    DocumentReference saleRef =
        await firestore.collection('Sales').add(sales.toJson());
    final customerDoc =
        await firestore.collection('Customers').doc(sales.customersId).get();

    if (customerDoc.exists) {
      CustomerModel customer =
          CustomerModel.fromJson(customerDoc.data()!, id: customerDoc.id);
      double netSale = customer.netSpend ?? 0.0;
      double newNetSale = netSale + sales.priceInNaira!;
      // Points accrued = 1% of sales price in Naira (Monetary Value)
      double pointsEarned = (sales.priceInNaira ?? 0.0) * 0.01;
      double currentPoints = customer.points ?? 0.0;
      double newPoints = currentPoints + pointsEarned;

      await firestore.collection('Customers').doc(sales.customersId).update({
        'netSpend': newNetSale,
        'points': FieldValue.increment(pointsEarned),
      });

      // Record Reward History (Earned)
      if (pointsEarned > 0) {
        final history = RewardHistoryModel(
          userId: sales.customersId!,
          amount: pointsEarned,
          type: 'earned',
          source: 'sale',
          relatedSaleId: saleRef.id,
          previousBalance: currentPoints,
          newBalance: newPoints,
          status: 'success',
          createdAt: DateTime.now(),
        );
        await firestore.collection('reward_history').add(history.toJson());
      }
    }

    double totalSales = (balance.totalSales ?? 0.0) + sales.priceInNaira!;
    await firestore
        .collection('GasBalance')
        .doc(balance.id)
        .update({'totalSales': totalSales});
  }

  Future<Map<String, dynamic>> getSales({DocumentSnapshot? lastDoc}) async {
    Query query = firestore
        .collection('Sales')
        .orderBy('createdAt', descending: true)
        .limit(100);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final querySnapshot = await query.get();

    final sales = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SalesModel.fromJson(data, docId: doc.id);
    }).toList();

    DocumentSnapshot? newLastDoc =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    return {'sales': sales, 'lastDoc': newLastDoc};
  }

  /// Fetches sales records from Firestore within a given date range.
  Future<List<SalesModel>> getSalesByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final querySnapshot = await firestore
          .collection('Sales')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return SalesModel.fromJson(data, docId: doc.id);
      }).toList();
    } catch (e) {
      logger.e('Error fetching sales by date range: $e');
      rethrow;
    }
  }

  Future<void> redeemPoints({
    required String customerId,
    required GasBalanceModel currentBalance,
  }) async {
    return firestore.runTransaction((transaction) async {
      // 1. READ: Get fresh customer data
      DocumentReference customerRef =
          firestore.collection('Customers').doc(customerId);
      DocumentSnapshot customerSnap = await transaction.get(customerRef);

      // 2. READ: Get fresh Gas Balance (Must be done before any writes)
      DocumentReference balanceRef =
          firestore.collection('GasBalance').doc(currentBalance.id);
      DocumentSnapshot balanceSnap = await transaction.get(balanceRef);

      // 3. LOGIC & VALIDATION
      if (!customerSnap.exists) throw Exception("Customer does not exist!");
      if (!balanceSnap.exists) throw Exception("Gas Balance not found!");

      CustomerModel customer =
          CustomerModel.fromJson(customerSnap.data() as Map<String, dynamic>);
      double currentPointsValue = customer.points ?? 0.0;
      double currentKg = balanceSnap.get('quantityKg') ?? 0.0;
      double pricePerKg = currentBalance.priceOfOneKg ?? 0.0;

      if (currentPointsValue <= 0) {
        throw Exception("No rewards available for redemption!");
      }

      if (pricePerKg <= 0) {
        throw Exception("Invalid gas price configuration!");
      }

      // Calculate how much Gas this monetary value can buy
      double gasAmountKg = currentPointsValue / pricePerKg;

      if (currentKg < gasAmountKg) {
        throw Exception("Insufficient gas inventory for redemption!");
      }

      // 4. WRITES
      // A. Reset points (Redeem All)
      transaction.update(customerRef, {'points': 0.0});

      // B. Deduct inventory (Equivalent gas amount)
      transaction.update(balanceRef, {'quantityKg': currentKg - gasAmountKg});

      // C. Record the "Redemption" Sale
      DocumentReference salesRef = firestore.collection('Sales').doc();
      final sale = SalesModel(
        id: salesRef.id,
        customersId: customerId,
        customersName: customer.name ?? 'Unknown',
        quantityInKg: gasAmountKg,
        priceInNaira: 0.0, // Free sale (covered by points)
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      transaction.set(salesRef, sale.toJson());

      // D. Record Reward History (Redeemed)
      DocumentReference historyRef =
          firestore.collection('reward_history').doc();
      final history = RewardHistoryModel(
        id: historyRef.id,
        userId: customerId,
        amount: currentPointsValue, // The full amount redeemed
        type: 'redeemed',
        source: 'redemption',
        relatedSaleId: salesRef.id, // Link to the free sale
        previousBalance: currentPointsValue,
        newBalance: 0.0, // Balance was reset
        status: 'success',
        createdAt: DateTime.now(),
      );
      transaction.set(historyRef, history.toJson());
    });
  }

  Future<List<RewardHistoryModel>> getRewardHistory(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('reward_history')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return RewardHistoryModel.fromJson(data, docId: doc.id);
      }).toList();
    } catch (e) {
      logger.e('Error fetching reward history: $e');
      rethrow;
    }
  }
}
