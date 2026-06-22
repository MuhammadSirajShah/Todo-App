


import 'package:flutter/scheduler.dart';


class TodoModel {
  String? id;
  String title;
  bool isDone;
  DateTime createdAt;
  DateTime? dueDate;
  bool isFavorite;


  TodoModel({
    this.id,
    required this.title,
    this.isDone = false,
    this.isFavorite = false,
    DateTime? createdAt,
    this.dueDate,
}): createdAt = createdAt ?? DateTime.now();

  // Convert object to Map

  Map<String, dynamic> toJson(){
    return {
      'title' : title,
      'isDone' : isDone,
      'isFavorite' : isFavorite,
      'createdAt' : createdAt.toIso8601String(),
      'dueDate' : dueDate?.toIso8601String(),
    };
  }

  // Convert Map to Object

  factory TodoModel.fromJson(Map<String , dynamic> json, String docId){
    return TodoModel(
      id: docId,
        title: json['title'],
        isDone: json['isDone'],
        isFavorite: json['isFavorite'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json["dueDate"])
            : null,

    );
  }
}



