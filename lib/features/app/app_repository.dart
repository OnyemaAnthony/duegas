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

  Future<void> saveGasBalance(GasBalanceModel balance) async {
    await firestore.collection('GasBalance').add(balance.toJson());
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

  Future<List<SalesModel>> getSales() async {
    final querySnapshot = await firestore
        .collection('Sales')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return SalesModel.fromJson(data, docId: doc.id);
    }).toList();
  }
}
