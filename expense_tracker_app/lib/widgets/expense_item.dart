// lib/widgets/expense_item.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final Function onDelete;
  final double totalIncome;
  final double totalExpense;

  ExpenseItem({
    required Key key,
    required this.expense,
    required this.onDelete,
    required this.totalIncome,
    required this.totalExpense, required bool isIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = totalIncome > 0 && expense.amount > 0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          expense.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(expense.date),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          
          onPressed: () => onDelete(expense.id, expense.amount),
        ),
      ),
    );
  }
}
