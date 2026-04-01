import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/supplier_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final supplierProvider = context.watch<SupplierProvider>();

    final report = txProvider.getMonthlyReport(_selectedMonth, _selectedYear);
    final totalReceivable = customerProvider.customers.fold(0.0, (sum, c) => sum + c.balance);
    final totalPayable = supplierProvider.suppliers.fold(0.0, (sum, s) => sum + s.balance);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthPicker(),
            const SizedBox(height: 24),
            _buildMonthlySummary(report['income'] ?? 0, report['expense'] ?? 0),
            const SizedBox(height: 32),
            _buildPaymentBreakdown(txProvider),
            const SizedBox(height: 32),
            _buildPartyBalances(totalReceivable, totalPayable),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.teal),
            const SizedBox(width: 12),
            Text(
              '${DateFormat('MMMM').format(DateTime(_selectedYear, _selectedMonth))} $_selectedYear',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => setState(() {
                if (_selectedMonth == 1) {
                  _selectedMonth = 12;
                  _selectedYear--;
                } else {
                  _selectedMonth--;
                }
              }),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: () => setState(() {
                if (_selectedMonth == 12) {
                  _selectedMonth = 1;
                  _selectedYear++;
                } else {
                  _selectedMonth++;
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlySummary(double income, double expense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Monthly Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCard('Total Income', '₹${income.toStringAsFixed(1)}', Colors.green, Icons.trending_up),
            const SizedBox(width: 16),
            _buildStatCard('Total Expense', '₹${expense.toStringAsFixed(1)}', Colors.red, Icons.trending_down),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.teal.shade100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Net Profit/Loss', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '₹${(income - expense).toStringAsFixed(1)}',
                style: TextStyle(
                  color: (income - expense) >= 0 ? Colors.green.shade800 : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String amount, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 4),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentBreakdown(TransactionProvider txProvider) {
    final cash = txProvider.cashBalance;
    final bank = txProvider.bankBalance;
    final upi = txProvider.upiBalance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Mode Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPaymentRow('Cash Flow', cash, Colors.orange),
        const SizedBox(height: 12),
        _buildPaymentRow('Bank Flow', bank, Colors.blue),
        const SizedBox(height: 12),
        _buildPaymentRow('UPI Flow', upi, Colors.purple),
      ],
    );
  }

  Widget _buildPaymentRow(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(height: 12, width: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('₹${amount.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPartyBalances(double receivable, double payable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Outstanding Balances', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.teal.shade700, Colors.teal.shade900]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildBalanceRow('Total Receivable (Customers)', receivable, Colors.green.shade200),
              const Divider(color: Colors.white24, height: 24),
              _buildBalanceRow('Total Payable (Suppliers)', payable, Colors.red.shade200),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow(String label, double amount, Color amountColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(
          '₹${amount.toStringAsFixed(1)}',
          style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
