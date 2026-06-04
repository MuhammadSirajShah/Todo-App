


import 'package:flutter/scheduler.dart';


class TodoModel {
  String title;
  bool isDone;
  DateTime createdAt;

  TodoModel({
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
}): createdAt = createdAt ?? DateTime.now();

  // Convert object to Map

  Map<String, dynamic> toJson(){
    return {
      'title' : title,
      'isDone' : isDone,
      'createdAt' : createdAt.toIso8601String(),
    };
  }

  // Convert Map to Object

  factory TodoModel.fromJson(
      Map<String , dynamic> json){
    return TodoModel(
        title: json['title'],
        isDone: json['isDone'],
        createdAt: DateTime.parse(
            json['createdAt'],
        ),

    );
  }
}



