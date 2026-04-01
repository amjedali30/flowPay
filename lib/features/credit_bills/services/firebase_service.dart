import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/supplier.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Supplier> get suppliers =>
      _firestore.collection('suppliers').withConverter<Supplier>(
            fromFirestore: (snapshot, _) => Supplier.fromJson(snapshot.data()!),
            toFirestore: (supplier, _) => supplier.toJson(),
          );

  CollectionReference<Customer> get customers =>
      _firestore.collection('customers').withConverter<Customer>(
            fromFirestore: (snapshot, _) => Customer.fromJson(snapshot.data()!),
            toFirestore: (customer, _) => customer.toJson(),
          );

  CollectionReference<TransactionModel> get transactions =>
      _firestore.collection('transactions').withConverter<TransactionModel>(
            fromFirestore: (snapshot, _) =>
                TransactionModel.fromJson(snapshot.data()!),
            toFirestore: (tx, _) => tx.toJson(),
          );

  FirebaseFirestore get firestore => _firestore;
}
