import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class ExpenseBreakdownScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseBreakdownScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final breakdown = txProvider.getCategoryBreakdown(
        TransactionType.OUT, startDate, endDate);
    
    final totalExpense = breakdown.values.fold(0.0, (sum, val) => sum + val);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('Expense Breakdown'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: breakdown.isEmpty
          ? const Center(child: Text('No expenses recorded for this period'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: breakdown.length,
              itemBuilder: (context, index) {
                final category = breakdown.keys.elementAt(index);
                final amount = breakdown[category]!;
                final percentage = totalExpense > 0 ? (amount / totalExpense) : 0.0;

                return _buildCategoryTile(category, amount, percentage);
              },
            ),
    );
  }

  Widget _buildCategoryTile(
      TransactionCategory category, double amount, double percentage) {
    final categoryName = category.name
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '₹${amount.toStringAsFixed(1)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade400),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% of total expense',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
