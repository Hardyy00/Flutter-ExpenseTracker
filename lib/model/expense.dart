import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "package:intl/intl.dart";

// to create to unique id
const uuid = Uuid();
final dateFormatter = DateFormat.yMd();

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

// to have fixed set of expense types
enum Category { food, travel, leisure, work }

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return dateFormatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenseList});

  // another constructor for filtering out expense belonging the a particular category
  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenseList = allExpense
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenseList;

  double get totalExpense {
    double sum = 0;

    for (final item in expenseList) {
      sum += item.amount;
    }

    return sum;
  }
}
