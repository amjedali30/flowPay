import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flow_pay/features/credit_bills/services/firebase_service.dart';
import 'package:flow_pay/features/credit_bills/repositories/supplier_repository.dart';
import 'package:flow_pay/features/credit_bills/providers/supplier_provider.dart';
import 'package:flow_pay/features/credit_bills/repositories/customer_repository.dart';
import 'package:flow_pay/features/credit_bills/repositories/transaction_repository.dart';
import 'package:flow_pay/features/credit_bills/providers/customer_provider.dart';
import 'package:flow_pay/features/credit_bills/providers/transaction_provider.dart';
import 'package:flow_pay/features/credit_bills/providers/settings_provider.dart';
import 'package:flow_pay/features/credit_bills/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final firebaseService = FirebaseService();
  final supplierRepo = SupplierRepository(firebaseService);
  final customerRepo = CustomerRepository(firebaseService);
  final transactionRepo = TransactionRepository(firebaseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),
        ChangeNotifierProvider(create: (_) => SupplierProvider(supplierRepo)..init()),
        ChangeNotifierProvider(create: (_) => CustomerProvider(customerRepo)..init()),
        ChangeNotifierProvider(create: (_) => TransactionProvider(transactionRepo)..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8), // Google Blue
          primary: const Color(0xFF1A73E8),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
