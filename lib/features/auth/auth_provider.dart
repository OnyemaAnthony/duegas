import 'dart:async';

import 'package:duegas/core/utils/error.dart';
import 'package:duegas/core/utils/logger.dart';
import 'package:duegas/features/auth/auth_repo.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:duegas/features/auth/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthRepository? repository;
  bool isLoading = false;
  UserModel? user;
  AppError? error;
  List<CustomerModel>? customers;
  StreamSubscription? _customerSubscription;

  AuthenticationProvider(this.repository) {
    _loadCustomers();
  }

  void _loadCustomers() async {
    try {
      isLoading = true;
      notifyListeners();
      _customerSubscription = repository?.getCustomers().listen(
        (customerList) {
          customers = customerList;
          error = null;
          isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCustomer(CustomerModel customer) async {
    try {
      isLoading = true;
      notifyListeners();
      await repository!.saveCustomer(customer);
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(UserModel userModel) async {
    try {
      isLoading = true;
      notifyListeners();
      repository!.createUserWithEmailAndPassword(userObject: userModel);
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();
      user = await repository!
          .signInWithEmailAndPassword(email: email, password: password);
      logger.d(user?.toJson());
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      isLoading = true;
      notifyListeners();
      await repository!.signOut();
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
