import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

import '../models/payment_type.dart';

class ExpenseBreakdownScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseBreakdownScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ExpenseBreakdownScreen> createState() => _ExpenseBreakdownScreenState();
}

class _ExpenseBreakdownScreenState extends State<ExpenseBreakdownScreen> {
  PaymentType? _selectedPaymentType;

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final breakdown = txProvider.getCategoryBreakdown(
      TransactionType.OUT,
      widget.startDate,
      widget.endDate,
      paymentType: _selectedPaymentType,
    );

    final totalExpense = breakdown.values.fold(0.0, (sum, val) => sum + val);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('Expense Breakdown'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildPaymentTypeFilter(),
          Expanded(
            child: breakdown.isEmpty
                ? const Center(child: Text('No expenses recorded for this filter'))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: breakdown.length,
                    itemBuilder: (context, index) {
                      final category = breakdown.keys.elementAt(index);
                      final amount = breakdown[category]!;
                      final percentage =
                          totalExpense > 0 ? (amount / totalExpense) : 0.0;

                      return _buildCategoryTile(category, amount, percentage);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedPaymentType == null,
              onSelected: (selected) {
                if (selected) setState(() => _selectedPaymentType = null);
              },
              selectedColor: Colors.red.shade100,
              checkmarkColor: Colors.red,
            ),
            const SizedBox(width: 8),
            ...PaymentType.values.map((type) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(type.name.toUpperCase()),
                  selected: _selectedPaymentType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPaymentType = selected ? type : null;
                    });
                  },
                  selectedColor: Colors.red.shade100,
                  checkmarkColor: Colors.red,
                ),
              );
            }),
          ],
        ),
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
