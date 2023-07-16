import "package:expense_tracker/model/expense.dart";
import "package:expense_tracker/widgets/expense_lists/expense_item.dart";
import "package:flutter/material.dart";

class ExpenseList extends StatelessWidget {
  ExpenseList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.2),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        key: ValueKey(expenses[index]),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenseItem: expenses[index],
        ),
      ),
    );
  }
}
