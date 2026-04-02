import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/payment_type.dart';
import '../providers/transaction_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/supplier_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType initialType;
  final TransactionModel? existingTransaction;

  const AddTransactionScreen({
    super.key,
    this.initialType = TransactionType.IN,
    this.existingTransaction,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TransactionType _type;
  late TransactionCategory _category;
  PaymentType _paymentType = PaymentType.cash;

  final _totalAmountController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String? _selectedPartyId;
  String? _selectedPartyName;

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final tx = widget.existingTransaction!;
      _type = tx.type;
      _category = tx.category;
      _paymentType = tx.paymentType;
      _totalAmountController.text = tx.totalAmount.toString();
      _paidAmountController.text = tx.paidAmount.toString();
      _noteController.text = tx.note ?? '';
      _selectedDate = tx.date;
      _selectedPartyId = tx.partyId;
      // We don't have the party name here easily, but we can fetch it or just show ID
      _selectedPartyName = tx.partyId != null ? 'Linked Party' : null;
    } else {
      _type = widget.initialType;
      _category = _type == TransactionType.IN
          ? TransactionCategory.sale
          : TransactionCategory.purchase;
    }

    _totalAmountController.addListener(_updatePaidAmount);
  }

  void _updatePaidAmount() {
    if (_paymentType != PaymentType.credit) {
      _paidAmountController.text = _totalAmountController.text;
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _paidAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();
    final supplierProvider = context.watch<SupplierProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_type == TransactionType.IN
            ? 'Cash In (Income)'
            : 'Cash Out (Expense)'),
        backgroundColor: _type == TransactionType.IN
            ? Colors.green.shade700
            : Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeSwitch(),
              const SizedBox(height: 24),
              _buildCategoryDropdown(),
              const SizedBox(height: 24),
              if (_categoryRequiresParty())
                _buildPartySelector(customerProvider, supplierProvider),
              const SizedBox(height: 24),
              _buildPaymentTypeSelector(),
              const SizedBox(height: 24),
              _buildAmountFields(),
              const SizedBox(height: 24),
              _buildDatePicker(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSwitch() {
    return SegmentedButton<TransactionType>(
      segments: const [
        ButtonSegment(
            value: TransactionType.IN,
            label: Text('IN (Income)'),
            icon: Icon(Icons.add)),
        ButtonSegment(
            value: TransactionType.OUT,
            label: Text('OUT (Expense)'),
            icon: Icon(Icons.remove)),
      ],
      selected: {_type},
      onSelectionChanged: (newSelection) {
        setState(() {
          _type = newSelection.first;
          _category = _type == TransactionType.IN
              ? TransactionCategory.sale
              : TransactionCategory.purchase;
          _selectedPartyId = null;
          _selectedPartyName = null;
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _type == TransactionType.IN
                ? Colors.green.shade100
                : Colors.red.shade100;
          }
          return null;
        }),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    List<TransactionCategory> categories = _type == TransactionType.IN
        ? [
            TransactionCategory.sale,
            TransactionCategory.payment_received,
            TransactionCategory.other
          ]
        : [
            TransactionCategory.purchase,
            TransactionCategory.payment_paid,
            TransactionCategory.expense,
            TransactionCategory.salary,
            TransactionCategory.other
          ];

    return DropdownButtonFormField<TransactionCategory>(
      // ignore: deprecated_member_use
      value: _category,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.category),
      ),
      items: categories.map((cat) {
        return DropdownMenuItem(
          value: cat,
          child: Text(cat.name
              .split('_')
              .map((e) => e[0].toUpperCase() + e.substring(1))
              .join(' ')),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) setState(() => _category = val);
      },
    );
  }

  bool _categoryRequiresParty() {
    return [
      TransactionCategory.sale,
      TransactionCategory.purchase,
      TransactionCategory.payment_received,
      TransactionCategory.payment_paid
    ].contains(_category);
  }

  bool _isPartyOptional() {
    return _category == TransactionCategory.sale;
  }

  bool _showSupplierPicker() {
    return [TransactionCategory.purchase, TransactionCategory.payment_paid]
        .contains(_category);
  }

  bool _showCustomerPicker() {
    return [TransactionCategory.sale, TransactionCategory.payment_received]
        .contains(_category);
  }

  Widget _buildPartySelector(CustomerProvider cp, SupplierProvider sp) {
    if (!_showCustomerPicker() && !_showSupplierPicker()) {
      return const SizedBox.shrink();
    }

    bool isCustomer = _showCustomerPicker();
    String label = isCustomer ? 'Select Customer' : 'Select Supplier';
    if (_isPartyOptional()) label += ' (Optional)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showPartyPicker(
              isCustomer ? cp.customers : sp.suppliers, isCustomer),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(isCustomer ? Icons.person : Icons.local_shipping,
                    color: const Color(0xFF1A73E8)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedPartyName ?? 'Click to select...',
                    style: TextStyle(
                      color: _selectedPartyName == null
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_selectedPartyId != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() {
                        _selectedPartyId = null;
                        _selectedPartyName = null;
                      });
                    },
                  ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPartyPicker(List<dynamic> parties, bool isCustomer) {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredParties = parties.where((p) {
              return p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  p.phone.contains(searchQuery);
            }).toList();

            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  Text(isCustomer ? 'Select Customer' : 'Select Supplier',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Expanded(
                    child: filteredParties.isEmpty
                        ? const Center(child: Text('No matching parties found'))
                        : ListView.builder(
                            itemCount: filteredParties.length,
                            itemBuilder: (context, index) {
                              final party = filteredParties[index];
                              return ListTile(
                                title: Text(party.name),
                                subtitle: Text(party.phone),
                                onTap: () {
                                  setState(() {
                                    _selectedPartyId = party.id;
                                    _selectedPartyName = party.name;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAmountFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _totalAmountController,
            decoration: InputDecoration(
              labelText: 'Total Amount',
              prefixText: '₹',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.number,
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter amount' : null,
          ),
        ),
        if (_categoryRequiresParty()) ...[
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _paidAmountController,
              decoration: InputDecoration(
                labelText: 'Paid Amount',
                prefixText: '₹',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              readOnly: _paymentType != PaymentType.credit,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter paid amount' : null,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Mode',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: PaymentType.values.map((type) {
            bool isCredit = type == PaymentType.credit;
            if (isCredit && !_categoryRequiresParty()) {
              return const SizedBox.shrink();
            }

            return ChoiceChip(
              label: Text(type.name.toUpperCase()),
              selected: _paymentType == type,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _paymentType = type;
                    if (type != PaymentType.credit) {
                      _paidAmountController.text = _totalAmountController.text;
                    }
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.teal),
            const SizedBox(width: 12),
            Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Icon(Icons.edit, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final txProvider = context.watch<TransactionProvider>();
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: txProvider.isLoading ? null : _saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: _type == TransactionType.IN
              ? Colors.green.shade700
              : Colors.red.shade700,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: txProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isPartyOptional() &&
        _categoryRequiresParty() &&
        _selectedPartyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_showCustomerPicker()
              ? 'Please select a customer'
              : 'Please select a supplier')));
      return;
    }

    final total = double.parse(_totalAmountController.text);
    final paid = double.parse(_paidAmountController.text);

    final tx = TransactionModel(
      id: widget.existingTransaction?.id ?? const Uuid().v4(),
      type: _type,
      category: _category,
      amount: total,
      paymentType: _paymentType,
      partyId: _selectedPartyId,
      partyType: _categoryRequiresParty()
          ? ([TransactionCategory.sale, TransactionCategory.payment_received]
                  .contains(_category)
              ? PartyType.customer
              : PartyType.supplier)
          : null,
      totalAmount: total,
      paidAmount: paid,
      balanceAmount: total - paid,
      isCredit: _paymentType == PaymentType.credit || (total - paid) > 0,
      date: _selectedDate,
      note: _noteController.text,
      createdAt: widget.existingTransaction?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.existingTransaction != null) {
        await context
            .read<TransactionProvider>()
            .updateTransaction(widget.existingTransaction!, tx);
      } else {
        await context.read<TransactionProvider>().addTransaction(tx);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(widget.existingTransaction != null
                ? 'Transaction updated successfully'
                : 'Transaction saved successfully')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
