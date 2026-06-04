

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Models/toto_model.dart';




enum TodoFilter{
  all,
  completed,
  pending,
}

class TodoProvider extends ChangeNotifier {

  final List<TodoModel> _todos = [];
  List<TodoModel> get todos => _todos;

  // add Todo

  void addTodo(String title){
    if(title.trim().isEmpty) return;
    _todos.add(TodoModel(title: title),
    );

    saveTodos();
    notifyListeners();
  }
  
  // delete Todo

  void deleteTodo(int index){
    _todos.removeAt(index);

    saveTodos();
    notifyListeners();
  }

  // toggle Todo

  void toggleTodo(int index){
    _todos[index].isDone = !_todos[index].isDone;

    saveTodos();
    notifyListeners();
  }


  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> todoList = _todos.map((todos) => jsonEncode(todos.toJson())).toList();

    await prefs.setStringList('todos', todoList);
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? todoList = prefs.getStringList('todos');
    if(todoList != null){
      _todos.clear();
      _todos.addAll(
        todoList.map((todo) => TodoModel.fromJson(jsonDecode(todo),
        )
        )
      );
    }
    notifyListeners();
  }

  void editTodo(int index, String newTitle){
    if(newTitle.trim().isEmpty) return;

    _todos[index].title = newTitle;

    saveTodos();
    notifyListeners();
  }

  String _searchQuery = "";

  void searchTodos(String query){
    _searchQuery = query;

    notifyListeners();
  }

  TodoFilter get currentFilter => _currentFilter;

  List<TodoModel> get filteredTodos{
    List<TodoModel> result = _todos;
    if(_searchQuery.isEmpty){
      result = result.where((todo){
        return todo.title.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
      }).toList();
      }
      // Status Filter
      switch (_currentFilter){
        case TodoFilter.completed:
          result = result
              .where((todo) => todo.isDone)
              .toList();
          break;
        case TodoFilter.pending:
          result = result
              .where((todo) => !todo.isDone)
              .toList();
          break;
        case TodoFilter.all:
          break;
      }
    return result;
  }

  TodoFilter _currentFilter = TodoFilter.all;

  void changeFilter(TodoFilter filter){
    _currentFilter = filter;
    notifyListeners();
  }
}