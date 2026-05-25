

import 'package:flutter/material.dart';
import 'package:todo_app/Models/toto_model.dart';

class TodoProvider extends ChangeNotifier {

  final List<TodoModel> _todos = [];
  List<TodoModel> get todos => _todos;

  // add Todo

  void addTodo(String title){
    if(title.trim().isEmpty) return;
    _todos.add(TodoModel(title: title),
    );
    notifyListeners();
  }
  
  // delete Todo

  void deleteTodo(int index){
    _todos.removeAt(index);

    notifyListeners();
  }

  // toggle Todo

  void toggleTodo(int index){
    _todos[index].isDone = !_todos[index].isDone;

    notifyListeners();
  }
}