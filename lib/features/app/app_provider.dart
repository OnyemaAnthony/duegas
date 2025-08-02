import 'package:duegas/core/utils/error.dart';
import 'package:duegas/features/app/app_repository.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final AppRepository repository;
  GasBalanceModel? gasBalance;
  bool isLoading = false;
  AppError? error;

  AppProvider({required this.repository}) {
    _listenToGasBalance();
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
