import 'todo_screen.dart';
import 'package:flutter/material.dart';

import 'package:sql_todolist_1/helpers/drawer_navigation.dart';

import 'package:sql_todolist_1/models/todo.dart';

import 'package:sql_todolist_1/services/todo_service.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;

  List<Todo> _todoList;

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList=[];
    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo()
          ..id = todo['id']
          ..title = todo['title']
          ..description = todo['description']
          ..category = todo['category']
          ..todoDate = todo['todoDate']
          ..isFinished = todo['isFinished'];

        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todolist sqflite'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              child: ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_todoList[index].title ?? 'No title'),
                    ]),
                subtitle: Text(_todoList[index].category ?? 'No Category'),
                trailing: Text(_todoList[index].todoDate ?? 'No Date'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
