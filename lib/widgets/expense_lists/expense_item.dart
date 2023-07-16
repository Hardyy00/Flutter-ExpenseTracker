import "package:expense_tracker/model/expense.dart";
import "package:flutter/material.dart";

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({required this.expenseItem, super.key});

  final Expense expenseItem;

  @override
  Widget build(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expenseItem.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                Text('\$${expenseItem.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expenseItem.category]),
                    const SizedBox(width: 6),
                    Text(expenseItem.formattedDate)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
