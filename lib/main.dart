import 'package:flutter/material.dart';
import 'package:valyuta_kursi/data/source/remote/service/api_service.dart';
import 'package:valyuta_kursi/ui/screens/currency/currency_screen.dart';

void main() async{

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CurrencyScreen(),
    );
  }
}