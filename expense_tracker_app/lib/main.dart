// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/expense_list_screen.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
             
            ),
        appBarTheme: AppBarTheme(
        
        ),
      ),
      home: ExpenseListScreen(),
    );
  }
}
