import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TodoTile({
    super.key,
    required this.title,
    required this.isDone,
    required this.onDelete,
    required this.onToggle


  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
            value: isDone,
            onChanged: (_){
              onToggle();
            },
            ),
        title: Text(title,style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone
                ? Colors.red
                : Colors.black,
            fontWeight: FontWeight.bold),),
        trailing: IconButton(onPressed: onDelete, icon: Icon(Icons.delete,color: Colors.red,)),
      ),
    );
  }
}
