import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/core/utils/error.dart';
import 'package:duegas/features/auth/auth_repo.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:duegas/features/auth/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthRepository? repository;
  bool isLoading = false;
  UserModel? user;
  AppError? error;
  // List<CustomerModel>? customers; // REMOVED DUPLICATE
  StreamSubscription? _customerSubscription;

  AuthenticationProvider(this.repository) {
    _loadCustomers();
    loadUser();
  }

  // Pagination State
  List<CustomerModel> _customers = [];
  List<CustomerModel>? get customers => _customers;

  DocumentSnapshot? _lastCustomerDoc;
  bool _hasMoreCustomers = true;
  bool _isFetchingMoreCustomers = false;
  String? _currentSearchQuery;

  bool get isFetchingMoreCustomers => _isFetchingMoreCustomers;
  bool get hasMoreCustomers => _hasMoreCustomers;

  // Initial fetch or search
  Future<void> getCustomers({String? query, bool refresh = false}) async {
    try {
      if (refresh) {
        _customers = [];
        _lastCustomerDoc = null;
        _hasMoreCustomers = true;
      }

      isLoading = true;
      _currentSearchQuery = query;
      notifyListeners();

      final result = await repository!.fetchCustomers(
        limit: 10,
        searchQuery: query,
      );

      _customers = result['customers'];
      _lastCustomerDoc = result['lastDoc'];
      _hasMoreCustomers = (result['customers'] as List).length == 10;
      error = null;
    } catch (e) {
      error = AppError.exception(e);
      // Don't rethrow here to avoid crashing UI, just show error state
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load more for pagination
  Future<void> getMoreCustomers() async {
    if (_isFetchingMoreCustomers || !_hasMoreCustomers) return;

    try {
      _isFetchingMoreCustomers = true;
      notifyListeners();

      final result = await repository!.fetchCustomers(
        lastDoc: _lastCustomerDoc,
        limit: 10,
        searchQuery: _currentSearchQuery,
      );

      final newCustomers = result['customers'] as List<CustomerModel>;
      _customers.addAll(newCustomers);
      _lastCustomerDoc = result['lastDoc'];

      // If we got fewer items than the limit, we've reached the end
      if (newCustomers.length < 10) {
        _hasMoreCustomers = false;
      }

      error = null;
    } catch (e) {
      error = AppError.exception(e);
    } finally {
      _isFetchingMoreCustomers = false;
      notifyListeners();
    }
  }

  void _loadCustomers() {
    // Initial load
    getCustomers();
  }

  Future<void> loadUser() async {
    try {
      isLoading = true;
      notifyListeners();
      user = await repository!.getUserById();
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
      await repository!.createUserWithEmailAndPassword(userObject: userModel);
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
