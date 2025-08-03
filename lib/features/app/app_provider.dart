import 'package:duegas/core/utils/error.dart';
import 'package:duegas/features/app/app_repository.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:duegas/features/app/model/sales_model.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final AppRepository repository;
  GasBalanceModel? gasBalance;
  bool isLoading = false;
  AppError? error;
  List<SalesModel>? sales;

  AppProvider({required this.repository}) {
    _listenToGasBalance();
    getSales();
  }

  Future<void> saveBalance(GasBalanceModel balance) async {
    try {
      isLoading = true;
      notifyListeners();
      await repository.saveGasBalance(balance);
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSales() async {
    try {
      isLoading = true;
      notifyListeners();
      sales = await repository.getSales();
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makeSales(SalesModel sales) async {
    try {
      isLoading = true;
      notifyListeners();
      await repository.makeSale(gasBalance!, sales);
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _listenToGasBalance() {
    repository.getGasBalance().listen((balance) {
      gasBalance = balance;
      notifyListeners();
    });
  }

  void refreshGasBalance() {
    _listenToGasBalance();
  }
}
