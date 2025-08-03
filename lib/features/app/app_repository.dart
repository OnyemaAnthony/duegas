import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:duegas/features/app/model/sales_model.dart';

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
  }
}
