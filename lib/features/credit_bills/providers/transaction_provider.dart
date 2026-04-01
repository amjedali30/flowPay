import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/payment_type.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository;

  TransactionProvider(this._repository);

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void init() {
    _repository.getAllTransactions().listen((transactions) {
      _transactions = transactions;
      notifyListeners();
    });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.addTransaction(transaction);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(
      TransactionModel oldTx, TransactionModel newTx) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updateTransaction(oldTx, newTx);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteTransaction(transaction);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Statistics based ONLY on paidAmount (actual cash flow)
  
  double get todayIncome {
    final today = DateTime.now();
    return _transactions
        .where((tx) =>
            tx.type == TransactionType.IN &&
            tx.date.year == today.year &&
            tx.date.month == today.month &&
            tx.date.day == today.day)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
  }

  double get todayExpense {
    final today = DateTime.now();
    return _transactions
        .where((tx) =>
            tx.type == TransactionType.OUT &&
            tx.date.year == today.year &&
            tx.date.month == today.month &&
            tx.date.day == today.day)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
  }

  double get cashBalance {
    double income = _transactions
        .where((tx) => tx.type == TransactionType.IN && tx.paymentType == PaymentType.cash)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
    double expense = _transactions
        .where((tx) => tx.type == TransactionType.OUT && tx.paymentType == PaymentType.cash)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
    return income - expense;
  }

  double get bankBalance {
    double income = _transactions
        .where((tx) => tx.type == TransactionType.IN && tx.paymentType == PaymentType.bank)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
    double expense = _transactions
        .where((tx) => tx.type == TransactionType.OUT && tx.paymentType == PaymentType.bank)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
    return income - expense;
  }

  double get upiBalance {
    double income = _transactions
        .where((tx) => tx.type == TransactionType.IN && tx.paymentType == PaymentType.upi)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
    double expense = _transactions
        .where((tx) => tx.type == TransactionType.OUT && tx.paymentType == PaymentType.upi)
        .fold(0.0, (sum, tx) => sum + tx.paidAmount);
    return income - expense;
  }

  // Reports
  Map<String, double> getMonthlyReport(int month, int year) {
    final filtered = _transactions.where((tx) => tx.date.month == month && tx.date.year == year);
    return {
      'income': filtered.where((tx) => tx.type == TransactionType.IN).fold(0.0, (s, tx) => s + tx.paidAmount),
      'expense': filtered.where((tx) => tx.type == TransactionType.OUT).fold(0.0, (s, tx) => s + tx.paidAmount),
    };
  }
}
