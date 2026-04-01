import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flow_pay/main.dart';
import 'package:flow_pay/features/credit_bills/providers/transaction_provider.dart';
import 'package:flow_pay/features/credit_bills/providers/customer_provider.dart';
import 'package:flow_pay/features/credit_bills/providers/supplier_provider.dart';
import 'package:flow_pay/features/credit_bills/providers/settings_provider.dart';
import 'package:flow_pay/features/credit_bills/screens/dashboard_screen.dart';
import 'package:flow_pay/features/credit_bills/repositories/transaction_repository.dart';
import 'package:flow_pay/features/credit_bills/repositories/customer_repository.dart';
import 'package:flow_pay/features/credit_bills/repositories/supplier_repository.dart';
import 'package:flow_pay/features/credit_bills/models/transaction.dart';
import 'package:flow_pay/features/credit_bills/models/customer.dart';
import 'package:flow_pay/features/credit_bills/models/supplier.dart';

class MockTransactionRepository implements TransactionRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<TransactionModel>> getAllTransactions() => Stream.value([]);
  
  @override
  Stream<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end) => Stream.value([]);
  
  @override
  Stream<List<TransactionModel>> getTransactionsByParty(String partyId) => Stream.value([]);
}

class MockCustomerRepository implements CustomerRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<Customer>> getCustomers() => Stream.value([]);
}

class MockSupplierRepository implements SupplierRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<Supplier>> getSuppliers() => Stream.value([]);
}

void main() {
  testWidgets('App loads DashboardScreen', (WidgetTester tester) async {
    final mockTxRepo = MockTransactionRepository();
    final mockCustRepo = MockCustomerRepository();
    final mockSuppRepo = MockSupplierRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),
          ChangeNotifierProvider(create: (_) => TransactionProvider(mockTxRepo)..init()),
          ChangeNotifierProvider(create: (_) => CustomerProvider(mockCustRepo)..init()),
          ChangeNotifierProvider(create: (_) => SupplierProvider(mockSuppRepo)..init()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
