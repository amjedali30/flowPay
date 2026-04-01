import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../repositories/customer_repository.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _repository;

  CustomerProvider(this._repository);

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void init() {
    _repository.getCustomers().listen((customers) {
      _customers = customers;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> addCustomer(Customer customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.addCustomer(customer);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.updateCustomer(customer);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.deleteCustomer(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
