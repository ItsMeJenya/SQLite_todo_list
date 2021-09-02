import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sql_todolist_1/models/todo.dart';
import 'package:sql_todolist_1/services/category_service.dart';
import 'package:sql_todolist_1/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();

  var _todoDescriptionController = TextEditingController();

  var _todoDateController = TextEditingController();
  var _selectedValue;
  List<DropdownMenuItem> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write Todo Title',
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Write Todo Description',
              ),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a Date',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              items: _categories,
              value: _selectedValue,
              hint: Text('Category'),
              onChanged: (value) {
                _selectedValue = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var todoObject = Todo()
                  ..title = _todoTitleController.text
                  ..description = _todoDescriptionController.text
                  ..isFinished = 0
                  ..category = _selectedValue.toString()
                  ..todoDate = _todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                print(result);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
