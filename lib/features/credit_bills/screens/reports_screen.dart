import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/supplier_provider.dart';
import 'income_breakdown_screen.dart';
import 'expense_breakdown_screen.dart';
import 'customer_list_screen.dart';
import 'supplier_list_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final supplierProvider = context.watch<SupplierProvider>();

    final report = txProvider.getReportByRange(_startDate, _endDate);
    final totalReceivable =
        customerProvider.customers.fold(0.0, (sum, c) => sum + c.balance);
    final totalPayable =
        supplierProvider.suppliers.fold(0.0, (sum, s) => sum + s.balance);

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
            _buildDateRangePicker(),
            const SizedBox(height: 24),
            _buildSummary(report['income'] ?? 0, report['expense'] ?? 0),
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

  Widget _buildDateRangePicker() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200)),
      child: InkWell(
        onTap: _selectDateRange,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.teal),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date Range',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    '${DateFormat('MMM d, yyyy').format(_startDate)} - ${DateFormat('MMM d, yyyy').format(_endDate)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.edit, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final initialRange = DateTimeRange(start: _startDate, end: _endDate);
    final newRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newRange != null) {
      setState(() {
        _startDate = newRange.start;
        _endDate = newRange.end;
      });
    }
  }

  Widget _buildSummary(double income, double expense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Financial Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCardWithAction(
              'Total Income',
              '₹${income.toStringAsFixed(1)}',
              Colors.green,
              Icons.trending_up,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IncomeBreakdownScreen(
                    startDate: _startDate,
                    endDate: _endDate,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildStatCardWithAction(
              'Total Expense',
              '₹${expense.toStringAsFixed(1)}',
              Colors.red,
              Icons.trending_down,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseBreakdownScreen(
                    startDate: _startDate,
                    endDate: _endDate,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Net Balance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '₹${(income - expense).toStringAsFixed(1)}',
                style: TextStyle(
                  color: (income - expense) >= 0
                      ? Colors.green.shade800
                      : Colors.red.shade800,
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

  Widget _buildStatCardWithAction(String label, String amount, Color color,
      IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: color, size: 24),
                      const Icon(Icons.arrow_forward_ios,
                          size: 12, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(label,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(amount,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('View Breakdown',
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
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
        const Text('Payment Mode Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('₹${amount.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPartyBalances(double receivable, double payable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Outstanding Balances',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade900]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildBalanceRow('Total Receivable (Customers)', receivable,
                  Colors.green.shade200, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerListScreen()),
                );
              }),
              const Divider(color: Colors.white24, height: 24),
              _buildBalanceRow(
                  'Total Payable (Suppliers)', payable, Colors.red.shade200,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupplierListScreen()),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow(
      String label, double amount, Color amountColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Row(
            children: [
              Text(
                '₹${amount.toStringAsFixed(1)}',
                style: TextStyle(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
