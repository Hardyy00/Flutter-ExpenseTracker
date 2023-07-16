import "package:flutter/material.dart";
import "package:expense_tracker/model/expense.dart"; // to import the date format object

// overlay screen
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.registerNewExpense});

  final void Function(Expense) registerNewExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // one way of storing user input

  // String _enteredTitle = '';

  // void saveEnteredTitle(title) {
  //   _enteredTitle = title;
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void validateTheData() {
    final amount = double.tryParse(_amountController.text);
    final isAmountInvalid = amount == null || amount <= 0;
    if (isAmountInvalid ||
        _titleController.text.trim().isEmpty ||
        _selectedDate == null) {
      // show error message

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              'Please Make Sure that the entered Title, Amount and Date are all valid.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );

      return;
    }
    // add expense in the expense list
    Expense newExpense = Expense(
        title: _titleController.text,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory);

    widget.registerNewExpense(newExpense);
    Navigator.pop(context);
  }

  void _openCalender() async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(2021, 6, 1); // month and date are optional
    final lastDate = DateTime(2025, 6, 1);
    final pickedDate = await showDatePicker(
      // wait for the future date value
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // below lines won't be executed until a date has been picked

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
          child: Column(
            children: [
              TextField(
                controller:
                    _titleController, // second way of handling user input
                // onChanged: saveEnteredTitle,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    // for the calender widget
                    child: Row(
                      // using the combination of text and an icon button to open the calender
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // when the date has not been picked show a not picked message
                        // but when it has been picked show the picked date
                        Text(_selectedDate == null
                            ? 'Date not Selected'
                            : dateFormatter.format(
                                _selectedDate!)), // ! to tell that _selectedDate won't be a null
                        IconButton(
                            onPressed: _openCalender,
                            icon: const Icon(Icons.calendar_month)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (categoryValue) => DropdownMenuItem(
                            value: categoryValue,
                            child: Text(
                              categoryValue.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      // print(value);
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.red),
                      )),
                  ElevatedButton(
                      onPressed: validateTheData,
                      child: const Text('Save Expense')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
