import 'package:sql_todolist_1/models/todo.dart';
import 'package:sql_todolist_1/repositories/repository.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  //Creating data
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  // read todos
  readTodos() async {
    return await _repository.readData('todos');
  }
}
