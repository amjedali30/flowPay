import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/supplier_provider.dart';
import '../models/transaction.dart';
import '../models/customer.dart';
import '../models/supplier.dart';
import 'transaction_detail_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final filteredTx = provider.transactions
        .where((tx) =>
            tx.date.year == _selectedDate.year &&
            tx.date.month == _selectedDate.month &&
            tx.date.day == _selectedDate.day)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    double totalIn = filteredTx
        .where((tx) => tx.type == TransactionType.IN)
        .fold(0, (sum, tx) => sum + tx.paidAmount);
    double totalOut = filteredTx
        .where((tx) => tx.type == TransactionType.OUT)
        .fold(0, (sum, tx) => sum + tx.paidAmount);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildDateHeader(context),
          _buildSummaryFilter(totalIn, totalOut),
          Expanded(
            child: filteredTx.isEmpty
                ? const Center(child: Text('No transactions for this date.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTx.length,
                    itemBuilder: (context, index) {
                      final tx = filteredTx[index];
                      return _buildTransactionTile(context, tx);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          DateFormat('EEEE, MMM d, y').format(_selectedDate),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing:
            const Icon(Icons.calendar_today, size: 20, color: Colors.teal),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (date != null) setState(() => _selectedDate = date);
        },
      ),
    );
  }

  Widget _buildSummaryFilter(double income, double expense) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildMiniStat('IN (Paid)', income, Colors.green),
          const SizedBox(width: 16),
          _buildMiniStat('OUT (Paid)', expense, Colors.red),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.5),

          //  color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('₹${amount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel tx) {
    final color = tx.type == TransactionType.IN ? Colors.green : Colors.red;
    final prefix = tx.type == TransactionType.IN ? '+' : '-';

    IconData icon;
    switch (tx.category) {
      case TransactionCategory.sale:
        icon = Icons.receipt_long;
        break;
      case TransactionCategory.purchase:
        icon = Icons.shopping_basket;
        break;
      case TransactionCategory.payment_received:
        icon = Icons.call_received;
        break;
      case TransactionCategory.payment_paid:
        icon = Icons.call_made;
        break;
      case TransactionCategory.expense:
        icon = Icons.outbox;
        break;
      case TransactionCategory.salary:
        icon = Icons.monetization_on;
        break;
      default:
        icon = Icons.swap_horiz;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                tx.category.name.replaceAll('_', ' ').toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            Text(
              tx.paymentType.name.toUpperCase(),
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              (tx.note ?? '').isEmpty ? 'No notes' : tx.note!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (tx.partyId != null) ...[
              const SizedBox(height: 2),
              Builder(
                builder: (context) {
                  String name = tx.partyId!.substring(0, 8);
                  if (tx.partyType == PartyType.customer) {
                    final customers = context.watch<CustomerProvider>().customers;
                    final customer = customers.cast<Customer?>().firstWhere(
                        (c) => c?.id == tx.partyId,
                        orElse: () => null);
                    if (customer != null) name = customer.name;
                  } else if (tx.partyType == PartyType.supplier) {
                    final suppliers = context.watch<SupplierProvider>().suppliers;
                    final supplier = suppliers.cast<Supplier?>().firstWhere(
                        (s) => s?.id == tx.partyId,
                        orElse: () => null);
                    if (supplier != null) name = supplier.name;
                  }
                  return Text(
                    'Party: $name',
                    style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  );
                },
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$prefix₹${tx.paidAmount.toStringAsFixed(1)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (tx.balanceAmount > 0)
              Text(
                'Bal: ₹${tx.balanceAmount.toStringAsFixed(1)}',
                style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transaction: tx),
            ),
          );
        },
      ),
    );
  }
}
