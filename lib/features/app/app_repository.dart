// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:duegas/core/utils/logger.dart';
// import 'package:duegas/features/app/model/gas_balance_model.dart';
// import 'package:duegas/features/app/model/sales_model.dart';
// import 'package:duegas/features/auth/model/customer_model.dart';
//
// class AppRepository {
//   final FirebaseFirestore firestore;
//
//   AppRepository({required this.firestore});
//
//   Stream<GasBalanceModel> getGasBalance() {
//     return FirebaseFirestore.instance
//         .collection('GasBalance')
//         .orderBy('createdAt', descending: true)
//         .limit(1)
//         .snapshots()
//         .map((snapshot) {
//       final doc = snapshot.docs.first;
//       logger.d(doc.data());
//
//       return GasBalanceModel.fromJson(doc.data(), id: doc.id);
//     });
//   }
//
//   Future<void> saveGasBalance(GasBalanceModel balance) async {
//     await firestore.collection('GasBalance').add(balance.toJson());
//   }
//
//   Future<void> makeSale(GasBalanceModel balance, SalesModel sales) async {
//     double remainingKg = (balance.quantityKg! - sales.quantityInKg!);
//     double remainingPrice = (balance.totalPrice! - sales.priceInNaira!);
//     Map<String, dynamic> gasBalanceUpdate = {
//       'quantityKg': remainingKg,
//       'totalPrice': remainingPrice
//     };
//     await firestore
//         .collection('GasBalance')
//         .doc(balance.id)
//         .update(gasBalanceUpdate);
//     await firestore.collection('Sales').add(sales.toJson());
//     final customerDoc =
//         await firestore.collection('Customers').doc(sales.customersId).get();
//
//     if (customerDoc.exists) {
//       CustomerModel customer =
//           CustomerModel.fromJson(customerDoc.data()!, id: customerDoc.id);
//       double netSale = customer.netSpend ?? 0.0;
//
//       double newNetSale = netSale + sales.priceInNaira!;
//
//       await firestore
//           .collection('Customers')
//           .doc(sales.customersId)
//           .update({'netSpend': newNetSale});
//     }
//
//     double totalSales = (balance.totalSales ?? 0.0) + sales.priceInNaira!;
//     await firestore
//         .collection('GasBalance')
//         .doc(balance.id)
//         .update({'totalSales': totalSales});
//   }
//
//   Future<Map<String, dynamic>> getSales({DocumentSnapshot? lastDoc}) async {
//     Query query = firestore
//         .collection('Sales')
//         .orderBy('createdAt', descending: true)
//         .limit(100);
//
//     if (lastDoc != null) {
//       query = query.startAfterDocument(lastDoc);
//     }
//
//     final querySnapshot = await query.get();
//
//     final sales = querySnapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       return SalesModel.fromJson(data, docId: doc.id);
//     }).toList();
//
//     DocumentSnapshot? newLastDoc =
//         querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
//
//     return {'sales': sales, 'lastDoc': newLastDoc};
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/core/utils/logger.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
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

  Future<void> saveGasBalance(GasBalanceModel balance, String docId) async {
    await firestore
        .collection('GasBalance')
        .doc(docId)
        .update(balance.toJson());
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
    await firestore.collection('Sales').add(sales.toJson());
    final customerDoc =
        await firestore.collection('Customers').doc(sales.customersId).get();

    if (customerDoc.exists) {
      CustomerModel customer =
          CustomerModel.fromJson(customerDoc.data()!, id: customerDoc.id);
      double netSale = customer.netSpend ?? 0.0;

      double newNetSale = netSale + sales.priceInNaira!;

      await firestore
          .collection('Customers')
          .doc(sales.customersId)
          .update({'netSpend': newNetSale});
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
}
