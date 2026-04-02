import '../models/transaction.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepository {
  final FirebaseService _service;

  TransactionRepository(this._service);

  Future<void> addTransaction(TransactionModel transaction) async {
    await _service.firestore.runTransaction((tx) async {
      // 1. Update Party Balance if applicable (Requires READS)
      if (transaction.partyId != null && transaction.partyType != null) {
        if (transaction.partyType == PartyType.customer) {
          final customerRef = _service.customers.doc(transaction.partyId);
          final customerSnap = await tx.get(customerRef);

          if (customerSnap.exists) {
            final customer = customerSnap.data()!;
            double balanceChange = 0;

            if (transaction.category == TransactionCategory.sale &&
                transaction.isCredit) {
              balanceChange = transaction.balanceAmount;
            } else if (transaction.category ==
                TransactionCategory.payment_received) {
              balanceChange = -transaction.amount;
            }

            if (balanceChange != 0) {
              tx.update(customerRef,
                  {'balance': customer.balance + balanceChange});
            }
          }
        } else if (transaction.partyType == PartyType.supplier) {
          final supplierRef = _service.suppliers.doc(transaction.partyId);
          final supplierSnap = await tx.get(supplierRef);

          if (supplierSnap.exists) {
            final supplier = supplierSnap.data()!;
            double balanceChange = 0;

            if (transaction.category == TransactionCategory.purchase &&
                transaction.isCredit) {
              balanceChange = transaction.balanceAmount;
            } else if (transaction.category == TransactionCategory.payment_paid) {
              balanceChange = -transaction.amount;
            }

            if (balanceChange != 0) {
              tx.update(supplierRef,
                  {'balance': supplier.balance + balanceChange});
            }
          }
        }
      }

      // 2. Add the transaction (Requires WRITE)
      final txRef = _service.transactions.doc(transaction.id);
      tx.set(txRef, transaction);
    });
  }

  Future<void> updateTransaction(
      TransactionModel oldTx, TransactionModel newTx) async {
    await _service.firestore.runTransaction((tx) async {
      // 1. Reads
      DocumentReference<dynamic>? oldPartyRef;
      DocumentSnapshot<dynamic>? oldPartySnap;
      DocumentReference<dynamic>? newPartyRef;
      DocumentSnapshot<dynamic>? newPartySnap;

      if (oldTx.partyId != null && oldTx.partyType != null) {
        oldPartyRef = oldTx.partyType == PartyType.customer
            ? _service.customers.doc(oldTx.partyId)
            : _service.suppliers.doc(oldTx.partyId);
        oldPartySnap = await tx.get(oldPartyRef);
      }

      if (newTx.partyId != null && newTx.partyType != null) {
        if (newTx.partyId == oldTx.partyId &&
            newTx.partyType == oldTx.partyType) {
          newPartyRef = oldPartyRef;
          newPartySnap = oldPartySnap;
        } else {
          newPartyRef = newTx.partyType == PartyType.customer
              ? _service.customers.doc(newTx.partyId)
              : _service.suppliers.doc(newTx.partyId);
          newPartySnap = await tx.get(newPartyRef);
        }
      }

      // 2. Calculate balance changes
      double oldPartyNetChange = 0;
      if (oldPartySnap != null && oldPartySnap.exists) {
        if (oldTx.partyType == PartyType.customer) {
          if (oldTx.category == TransactionCategory.sale && oldTx.isCredit) {
            oldPartyNetChange = -oldTx.balanceAmount;
          } else if (oldTx.category == TransactionCategory.payment_received) {
            oldPartyNetChange = oldTx.amount;
          }
        } else {
          if (oldTx.category == TransactionCategory.purchase &&
              oldTx.isCredit) {
            oldPartyNetChange = -oldTx.balanceAmount;
          } else if (oldTx.category == TransactionCategory.payment_paid) {
            oldPartyNetChange = oldTx.amount;
          }
        }
      }

      double newPartyNetChange = 0;
      if (newPartySnap != null && newPartySnap.exists) {
        if (newTx.partyType == PartyType.customer) {
          if (newTx.category == TransactionCategory.sale && newTx.isCredit) {
            newPartyNetChange = newTx.balanceAmount;
          } else if (newTx.category == TransactionCategory.payment_received) {
            newPartyNetChange = -newTx.amount;
          }
        } else {
          if (newTx.category == TransactionCategory.purchase &&
              newTx.isCredit) {
            newPartyNetChange = newTx.balanceAmount;
          } else if (newTx.category == TransactionCategory.payment_paid) {
            newPartyNetChange = -newTx.amount;
          }
        }
      }

      // 3. Writes
      if (oldPartyRef != null &&
          oldPartySnap != null &&
          oldPartySnap.exists &&
          oldPartyNetChange != 0) {
        final currentBal = oldPartySnap.data()?.balance ?? 0.0;
        tx.update(oldPartyRef, {'balance': currentBal + oldPartyNetChange});
      }

      if (newPartyRef != null &&
          newPartySnap != null &&
          newPartySnap.exists &&
          newPartyNetChange != 0) {
        if (newPartyRef == oldPartyRef) {
          final currentBal = oldPartySnap!.data()?.balance ?? 0.0;
          tx.update(newPartyRef,
              {'balance': currentBal + oldPartyNetChange + newPartyNetChange});
        } else {
          final currentBal = newPartySnap.data()?.balance ?? 0.0;
          tx.update(newPartyRef, {'balance': currentBal + newPartyNetChange});
        }
      }

      final txRef = _service.transactions.doc(newTx.id);
      tx.set(txRef, newTx);
    });
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _service.firestore.runTransaction((tx) async {
      // 1. Reverse Party Balance update (Requires READS)
      if (transaction.partyId != null && transaction.partyType != null) {
        if (transaction.partyType == PartyType.customer) {
          final customerRef = _service.customers.doc(transaction.partyId);
          final customerSnap = await tx.get(customerRef);

          if (customerSnap.exists) {
            final customer = customerSnap.data()!;
            double balanceChange = 0;

            if (transaction.category == TransactionCategory.sale &&
                transaction.isCredit) {
              balanceChange = -transaction.balanceAmount;
            } else if (transaction.category ==
                TransactionCategory.payment_received) {
              balanceChange = transaction.amount;
            }

            if (balanceChange != 0) {
              tx.update(customerRef,
                  {'balance': customer.balance + balanceChange});
            }
          }
        } else if (transaction.partyType == PartyType.supplier) {
          final supplierRef = _service.suppliers.doc(transaction.partyId);
          final supplierSnap = await tx.get(supplierRef);

          if (supplierSnap.exists) {
            final supplier = supplierSnap.data()!;
            double balanceChange = 0;

            if (transaction.category == TransactionCategory.purchase &&
                transaction.isCredit) {
              balanceChange = -transaction.balanceAmount;
            } else if (transaction.category ==
                TransactionCategory.payment_paid) {
              balanceChange = transaction.amount;
            }

            if (balanceChange != 0) {
              tx.update(supplierRef,
                  {'balance': supplier.balance + balanceChange});
            }
          }
        }
      }

      // 2. Delete the transaction (Requires WRITE)
      final txRef = _service.transactions.doc(transaction.id);
      tx.delete(txRef);
    });
  }

  Stream<List<TransactionModel>> getAllTransactions() {
    return _service.transactions
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _service.transactions
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
  
  Stream<List<TransactionModel>> getTransactionsByParty(String partyId) {
    return _service.transactions
        .where('partyId', isEqualTo: partyId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
