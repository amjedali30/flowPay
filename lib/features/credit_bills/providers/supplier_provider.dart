import 'package:flutter/foundation.dart';
import '../models/supplier.dart';
import '../repositories/supplier_repository.dart';

class SupplierProvider with ChangeNotifier {
  final SupplierRepository _repository;

  SupplierProvider(this._repository);

  List<Supplier> _suppliers = [];
  List<Supplier> get suppliers => _suppliers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void init() {
    _repository.getSuppliers().listen(
      (data) {
        _suppliers = data;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> addSupplier(Supplier supplier) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.addSupplier(supplier);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.updateSupplier(supplier);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSupplier(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.deleteSupplier(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
