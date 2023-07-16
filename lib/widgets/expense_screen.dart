import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_lists/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import "package:flutter/material.dart";
import '../model/expense.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  State<ExpenseScreen> createState() {
    return _ExpenseScreenState();
  }
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final List<Expense> expenseList = [
    // Expense(
    //     title: 'Flutter Course',
    //     amount: 20.23,
    //     date: DateTime.now(),
    //     category: Category.work),
    // Expense(
    //     title: 'Movie',
    //     amount: 10.50,
    //     date: DateTime.now(),
    //     category: Category.leisure)
  ];

  void _registerNewExpense(Expense expense) {
    setState(() {
      expenseList.add(expense);
    });
  }

  void _deleteExpense(Expense expense) {
    var expenseIndex = expenseList.indexOf(expense);
    setState(() {
      expenseList.remove(expense);
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.vertical,
        content: const Text("You removed an expense"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                expenseList.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        constraints: const BoxConstraints(maxWidth: double.infinity),
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(registerNewExpense: _registerNewExpense));
  }

  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width;
    print(width);
    Widget mainContent = const Center(
      child: Text(
        "No Expenses to Display",
        style: TextStyle(fontSize: 18),
      ),
    );

    if (expenseList.isNotEmpty) {
      mainContent = width < 600
          ? Column(
              children: [
                Chart(expenses: expenseList),
                const SizedBox(height: 10),
                Expanded(
                  child: ExpenseList(
                    expenses: expenseList,
                    onRemoveExpense: _deleteExpense,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: expenseList)),
                const SizedBox(height: 10),
                Expanded(
                  child: ExpenseList(
                    expenses: expenseList,
                    onRemoveExpense: _deleteExpense,
                  ),
                ),
              ],
            );
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Expense App",
          ),
          actions: [
            IconButton(
                onPressed: _openAddExpenseOverlay,
                icon: const Icon(Icons.add, color: Colors.purple))
          ]),
      body: mainContent,
    );
  }
}
