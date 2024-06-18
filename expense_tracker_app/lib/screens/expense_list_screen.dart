import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../widgets/expense_item.dart';
import '../screens/add_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> incomes = [];
  List<Expense> expenses = [];
  bool initialIncomeAdded = false;

  double get totalIncome =>
      incomes.fold(0, (sum, income) => sum + income.amount);

  double get totalExpense =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);

  double get totalBalance => totalIncome - totalExpense;

  void _addIncome(String title, double amount) {
    final newIncome = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    setState(() {
      incomes.add(newIncome);
      initialIncomeAdded = true; // Set flag to true once initial income is added
    });

    _showIncomeAddedDialog(newIncome); // Show dialog with income details
  }

  void _showIncomeAddedDialog(Expense income) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Income Added"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Title: ${income.title}"),
              Text("Amount: \$${income.amount.toStringAsFixed(2)}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _addExpense(String title, double amount) {
    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    setState(() {
      expenses.add(newExpense);
    });

    _showExpenseAddedDialog(newExpense); // Show dialog with expense details
  }

  void _showExpenseAddedDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Expense Added"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Title: ${expense.title}"),
              Text("Amount: \$${expense.amount.toStringAsFixed(2)}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteIncome(String id, double amount) {
    setState(() {
      incomes.removeWhere((income) => income.id == id);
      if (incomes.isEmpty) {
        initialIncomeAdded = false; // Reset flag if incomes list becomes empty
      }
    });
  }

  void _deleteExpense(String id, double amount) {
    setState(() {
      expenses.removeWhere((expense) => expense.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Income:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${totalIncome.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Expenses:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${totalExpense.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Balance:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${totalBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: totalBalance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: incomes.length + expenses.length,
              itemBuilder: (ctx, index) {
                if (index < incomes.length) {
                  return ExpenseItem(
                    key: ValueKey(incomes[index].id),
                    expense: incomes[index],
                    onDelete: _deleteIncome,
                    isIncome: true,
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                  );
                } else {
                  final expenseIndex = index - incomes.length;
                  return ExpenseItem(
                    key: ValueKey(expenses[expenseIndex].id),
                    expense: expenses[expenseIndex],
                    onDelete: _deleteExpense,
                    isIncome: false,
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => AddExpenseScreen(_addExpense),
          ));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String title = '';
                    String amount = ''; // Changed to String for TextField

                    return AlertDialog(
                      title: Text("Add Income"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(labelText: 'Title'),
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              amount = value; // Store as String
                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Add Income"),
                          onPressed: () {
                            double parsedAmount =
                                double.tryParse(amount) ?? 0.0;
                            if (title.isNotEmpty &&
                                parsedAmount > 0) {
                              _addIncome(title, parsedAmount);
                              Navigator.of(context).pop(); // Close dialog
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Invalid Input"),
                                    content: Text(
                                        "Please enter valid title and amount for income."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Income'),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String title = '';
                    String amount = ''; // Changed to String for TextField

                    return AlertDialog(
                      title: Text("Add Expense"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(labelText: 'Title'),
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              amount = value; // Store as String
                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Add Expense"),
                          onPressed: () {
                            double parsedAmount =
                                double.tryParse(amount) ?? 0.0;
                            if (title.isNotEmpty &&
                                parsedAmount > 0) {
                              _addExpense(title, parsedAmount);
                              Navigator.of(context).pop(); // Close dialog
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Invalid Input"),
                                    content: Text(
                                        "Please enter valid title and amount for expense."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
