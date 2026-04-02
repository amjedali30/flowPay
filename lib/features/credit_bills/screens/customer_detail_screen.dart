import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/customer_provider.dart';
import 'add_transaction_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();
    final currentCustomer = customerProvider.customers.firstWhere(
      (c) => c.id == customer.id,
      orElse: () => customer,
    );
    final txProvider = context.watch<TransactionProvider>();
    final customerTransactions = txProvider.transactions
        .where((tx) => tx.partyId == currentCustomer.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Text(currentCustomer.name),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSummaryHeader(context, currentCustomer),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Transaction History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: customerTransactions.isEmpty
                ? const Center(
                    child: Text('No transactions found for this customer.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: customerTransactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionTile(
                          context, customerTransactions[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AddTransactionScreen(initialType: TransactionType.IN),
          ),
        ),
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, Customer currentCustomer) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Balance Receivable',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                '₹${currentCustomer.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const AddTransactionScreen(initialType: TransactionType.IN),
              ),
            ),
            icon: const Icon(Icons.payment),
            label: const Text('Receive Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade100,
              foregroundColor: Colors.orange.shade900,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel tx) {
    final bool isSale = tx.category == TransactionCategory.sale;
    final color = isSale ? Colors.orange : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(isSale ? Icons.shopping_basket : Icons.payment,
              color: color, size: 20),
        ),
        title: Text(tx.category.name.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        subtitle: Text(
          '${tx.date.toString().substring(0, 10)} - ${tx.paymentType.name.toUpperCase()}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${tx.totalAmount.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            if (tx.balanceAmount > 0)
              Text(
                'Unpaid: ₹${tx.balanceAmount.toStringAsFixed(1)}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
