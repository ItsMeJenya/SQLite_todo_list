import 'package:flutter/material.dart';
import 'package:sql_todolist_1/models/todo.dart';
import 'package:sql_todolist_1/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  TodosByCategory(this.category);

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = [];
  TodoService _todoService = TodoService();

  @override
  initState() {
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);

    todos.forEach((todo) {
      setState(() {
        var model = Todo()
          ..title = todo['title']
          ..description = todo['description']
          ..todoDate = todo['todoDate'];

        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      elevation: 10.0,
                      child: ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_todoList[index].title ?? 'No title'),
                            ]),
                        subtitle: Text(
                            _todoList[index].description ?? 'No Description'),
                        trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
