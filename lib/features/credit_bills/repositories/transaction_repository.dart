import '../models/transaction.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepository {
  final FirebaseService _service;

  TransactionRepository(this._service);

  Future<void> addTransaction(TransactionModel transaction) async {
    await _service.firestore.runTransaction((tx) async {
      // 1. Update Party Balances if applicable (Requires READS)
      
      // A. Main Party Change (for direct payments/receipts)
      if (transaction.partyId != null && transaction.partyType != null) {
        if (transaction.category == TransactionCategory.payment_received ||
            transaction.category == TransactionCategory.payment_paid) {
          
        if (transaction.partyType == PartyType.customer) {
          final partyRef = _service.customers.doc(transaction.partyId);
          final partySnap = await tx.get(partyRef);
          if (partySnap.exists) {
            final party = partySnap.data()!;
            tx.update(partyRef, {'balance': party.balance - transaction.amount});
          }
        } else {
          final partyRef = _service.suppliers.doc(transaction.partyId);
          final partySnap = await tx.get(partyRef);
          if (partySnap.exists) {
            final party = partySnap.data()!;
            tx.update(partyRef, {'balance': party.balance - transaction.amount});
          }
        }
        }
      }

      // B. Credit Party Change (for balances/split payments)
      final creditPartyId = transaction.creditPartyId ?? transaction.partyId;
      final creditPartyType = transaction.creditPartyType ?? transaction.partyType;

      if (creditPartyId != null && creditPartyType != null && transaction.isCredit) {
        if (transaction.category != TransactionCategory.payment_received &&
            transaction.category != TransactionCategory.payment_paid) {
          
        if (creditPartyType == PartyType.customer) {
          final creditPartyRef = _service.customers.doc(creditPartyId);
          final creditPartySnap = await tx.get(creditPartyRef);
          if (creditPartySnap.exists) {
            final creditParty = creditPartySnap.data()!;
            tx.update(creditPartyRef, {'balance': creditParty.balance + transaction.balanceAmount});
          }
        } else {
          final creditPartyRef = _service.suppliers.doc(creditPartyId);
          final creditPartySnap = await tx.get(creditPartyRef);
          if (creditPartySnap.exists) {
            final creditParty = creditPartySnap.data()!;
            tx.update(creditPartyRef, {'balance': creditParty.balance + transaction.balanceAmount});
          }
        }
        }
      }


      // 2. Add the transaction (Requires WRITE)
      final txRef = _service.transactions.doc(transaction.id);
      tx.set(txRef, transaction);
    });
  }

  Future<void> updateTransaction(TransactionModel oldTx, TransactionModel newTx) async {
    await _service.firestore.runTransaction((tx) async {
      // 1. Reverse effects of oldTx
      
      // A. Main Party Reverse
      if (oldTx.partyId != null && oldTx.partyType != null) {
        if (oldTx.category == TransactionCategory.payment_received ||
            oldTx.category == TransactionCategory.payment_paid) {
          if (oldTx.partyType == PartyType.customer) {
            final ref = _service.customers.doc(oldTx.partyId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance + oldTx.amount});
          } else {
            final ref = _service.suppliers.doc(oldTx.partyId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance + oldTx.amount});
          }
        }
      }

      // B. Credit Party Reverse
      final oldCreditId = oldTx.creditPartyId ?? oldTx.partyId;
      final oldCreditType = oldTx.creditPartyType ?? oldTx.partyType;
      if (oldCreditId != null && oldCreditType != null && oldTx.isCredit) {
        if (oldTx.category != TransactionCategory.payment_received &&
            oldTx.category != TransactionCategory.payment_paid) {
          if (oldCreditType == PartyType.customer) {
            final ref = _service.customers.doc(oldCreditId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance - oldTx.balanceAmount});
          } else {
            final ref = _service.suppliers.doc(oldCreditId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance - oldTx.balanceAmount});
          }
        }
      }

      // 2. Apply effects of newTx
      
      // A. Main Party Apply
      if (newTx.partyId != null && newTx.partyType != null) {
        if (newTx.category == TransactionCategory.payment_received ||
            newTx.category == TransactionCategory.payment_paid) {
          if (newTx.partyType == PartyType.customer) {
            final ref = _service.customers.doc(newTx.partyId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance - newTx.amount});
          } else {
            final ref = _service.suppliers.doc(newTx.partyId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance - newTx.amount});
          }
        }
      }

      // B. Credit Party Apply
      final newCreditId = newTx.creditPartyId ?? newTx.partyId;
      final newCreditType = newTx.creditPartyType ?? newTx.partyType;
      if (newCreditId != null && newCreditType != null && newTx.isCredit) {
        if (newTx.category != TransactionCategory.payment_received &&
            newTx.category != TransactionCategory.payment_paid) {
          if (newCreditType == PartyType.customer) {
            final ref = _service.customers.doc(newCreditId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance + newTx.balanceAmount});
          } else {
            final ref = _service.suppliers.doc(newCreditId);
            final snap = await tx.get(ref);
            if (snap.exists) tx.update(ref, {'balance': snap.data()!.balance + newTx.balanceAmount});
          }
        }
      }

      // 3. Update the transaction record
      final txRef = _service.transactions.doc(newTx.id);
      tx.set(txRef, newTx);
    });
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _service.firestore.runTransaction((tx) async {
      // 1. Reverse Party Balances if applicable (Requires READS)
      
      // A. Main Party Reverse
      if (transaction.partyId != null && transaction.partyType != null) {
        if (transaction.category == TransactionCategory.payment_received ||
            transaction.category == TransactionCategory.payment_paid) {
          
          if (transaction.partyType == PartyType.customer) {
            final partyRef = _service.customers.doc(transaction.partyId);
            final partySnap = await tx.get(partyRef);
            if (partySnap.exists) {
              final party = partySnap.data()!;
              tx.update(partyRef, {'balance': party.balance + transaction.amount});
            }
          } else {
            final partyRef = _service.suppliers.doc(transaction.partyId);
            final partySnap = await tx.get(partyRef);
            if (partySnap.exists) {
              final party = partySnap.data()!;
              tx.update(partyRef, {'balance': party.balance + transaction.amount});
            }
          }
        }
      }

      // B. Credit Party Reverse
      final creditPartyId = transaction.creditPartyId ?? transaction.partyId;
      final creditPartyType = transaction.creditPartyType ?? transaction.partyType;

      if (creditPartyId != null && creditPartyType != null && transaction.isCredit) {
        if (transaction.category != TransactionCategory.payment_received &&
            transaction.category != TransactionCategory.payment_paid) {
          
          if (creditPartyType == PartyType.customer) {
            final creditPartyRef = _service.customers.doc(creditPartyId);
            final creditPartySnap = await tx.get(creditPartyRef);
            if (creditPartySnap.exists) {
              final creditParty = creditPartySnap.data()!;
              tx.update(creditPartyRef, {'balance': creditParty.balance - transaction.balanceAmount});
            }
          } else {
            final creditPartyRef = _service.suppliers.doc(creditPartyId);
            final creditPartySnap = await tx.get(creditPartyRef);
            if (creditPartySnap.exists) {
              final creditParty = creditPartySnap.data()!;
              tx.update(creditPartyRef, {'balance': creditParty.balance - transaction.balanceAmount});
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
