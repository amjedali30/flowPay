import '../models/supplier.dart';
import '../services/firebase_service.dart';

class SupplierRepository {
  final FirebaseService _service;

  SupplierRepository(this._service);

  Future<void> addSupplier(Supplier supplier) async {
    await _service.suppliers.doc(supplier.id).set(supplier);
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await _service.suppliers.doc(supplier.id).update(supplier.toJson());
  }

  Future<void> deleteSupplier(String id) async {
    await _service.suppliers.doc(id).delete();
  }

  Stream<List<Supplier>> getSuppliers() {
    return _service.suppliers
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Supplier?> getSupplierById(String id) async {
    final doc = await _service.suppliers.doc(id).get();
    return doc.data();
  }
}
