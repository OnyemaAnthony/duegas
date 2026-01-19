import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/core/utils/error.dart';
import 'package:duegas/features/app/app_repository.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:duegas/features/app/model/reward_history_model.dart';
import 'package:duegas/features/app/model/sales_model.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final AppRepository repository;
  GasBalanceModel? gasBalance;
  bool isLoading = false;
  bool isFetchingMore = false;
  AppError? error;

  List<SalesModel> sales = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMoreSales = true;

  // New properties for date filtering
  List<SalesModel> _filteredSales = [];
  List<SalesModel> get filteredSales => _filteredSales;

  List<RewardHistoryModel> _rewardHistory = [];
  List<RewardHistoryModel> get rewardHistory => _rewardHistory;

  String _selectedFilter = '7D'; // Default filter
  String get selectedFilter => _selectedFilter;

  DateTime? _customDate;
  DateTime? get customDate => _customDate;

  /// Calculates total sales from the currently filtered list.
  double get totalFilteredSales {
    return _filteredSales.fold(
        0.0, (sum, sale) => sum + (sale.priceInNaira ?? 0.0));
  }

  AppProvider({required this.repository}) {
    _listenToGasBalance();
    getSales(); // For the paginated "All Sales" screen
    fetchSalesByFilter('7D'); // Initial fetch for the dashboard chart
  }

  /// Fetches sales data based on a selected filter type ('1D', '7D', '30D', 'Custom').
  Future<void> fetchSalesByFilter(String filter, {DateTime? date}) async {
    _selectedFilter = filter;
    _customDate = date;
    isLoading = true;
    notifyListeners();

    try {
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate = now;

      switch (filter) {
        case '1D':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case '7D':
          // Go back 6 days from today to get a total of 7 days
          var sixDaysAgo = now.subtract(const Duration(days: 6));
          startDate =
              DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day);
          break;
        case '30D':
          // Go back 29 days from today to get a total of 30 days
          var twentyNineDaysAgo = now.subtract(const Duration(days: 29));
          startDate = DateTime(twentyNineDaysAgo.year, twentyNineDaysAgo.month,
              twentyNineDaysAgo.day);
          break;
        case 'Custom':
          if (date != null) {
            startDate = DateTime(date.year, date.month, date.day);
            // End of the selected day
            endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
          } else {
            // Default to today if custom date is not provided
            startDate = DateTime(now.year, now.month, now.day);
          }
          break;
        default:
          // Default to 7 days if filter is unknown
          var sixDaysAgo = now.subtract(const Duration(days: 6));
          startDate =
              DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day);
      }

      _filteredSales = await repository.getSalesByDateRange(startDate, endDate);
    } catch (e) {
      error = AppError.exception(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBalance(GasBalanceModel balance, {String? docId}) async {
    try {
      isLoading = true;
      notifyListeners();
      await repository.saveGasBalance(balance, docId: docId);
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
      final result = await repository.getSales();
      sales = result['sales'];
      _lastDocument = result['lastDoc'];
      _hasMoreSales = sales.length == 100;
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMoreSales() async {
    if (isFetchingMore || !_hasMoreSales) return;

    try {
      isFetchingMore = true;
      notifyListeners();
      final result = await repository.getSales(lastDoc: _lastDocument);
      final moreSales = result['sales'];
      sales.addAll(moreSales);
      _lastDocument = result['lastDoc'];
      _hasMoreSales = moreSales.isNotEmpty;
    } catch (e) {
      error = AppError.exception(e);
    } finally {
      isFetchingMore = false;
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

  Future<void> redeemPoints({
    required String customerId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      if (gasBalance == null) throw Exception("Gas Balance not loaded");

      await repository.redeemPoints(
        customerId: customerId,
        currentBalance: gasBalance!,
      );

      // Refresh history if we are currently viewing it for this customer
      await getRewardHistory(customerId);
    } catch (e) {
      error = AppError.exception(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRewardHistory(String userId) async {
    try {
      // Don't set global isLoading to avoid full screen loader if just switching tabs
      final history = await repository.getRewardHistory(userId);
      _rewardHistory = history;
      notifyListeners();
    } catch (e) {
      error = AppError.exception(e);
      // Don't rethrow, just log/show error state
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
