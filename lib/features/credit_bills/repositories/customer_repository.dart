import '../models/customer.dart';
import '../services/firebase_service.dart';

class CustomerRepository {
  final FirebaseService _service;

  CustomerRepository(this._service);

  Future<void> addCustomer(Customer customer) async {
    await _service.customers.doc(customer.id).set(customer);
  }

  Future<void> updateCustomer(Customer customer) async {
    await _service.customers.doc(customer.id).update(customer.toJson());
  }

  Future<void> deleteCustomer(String id) async {
    await _service.customers.doc(id).delete();
  }

  Stream<List<Customer>> getCustomers() {
    return _service.customers
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Customer?> getCustomerById(String id) async {
    final doc = await _service.customers.doc(id).get();
    return doc.data();
  }
}
