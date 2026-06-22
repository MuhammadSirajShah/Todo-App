import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Models/toto_model.dart';

class TodoTile extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const TodoTile({
    super.key,
    required this.title,
    required this.isDone,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
    required this.createdAt,
    required this.dueDate,
    required this.isFavorite,
    required this.onFavorite

  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      onDismissed: (_){
        onDelete();
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(right: 20),
        color: Colors.green,
        child: Icon(Icons.check,color: Colors.white,
          size: 30,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(Icons.delete,color: Colors.white,size: 30,),
      ),
      confirmDismiss: (direction) async {
        if(direction == DismissDirection.startToEnd){
          onToggle();
          return false;
        }
        if(direction == DismissDirection.endToStart){
          return true;
        }
        return false;
      },
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 400,
        ),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        decoration: BoxDecoration(
          color: isDone
              ? Colors.green.shade100
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Checkbox(
              value: isDone,
              onChanged: (_){
                onToggle();
              },
              ),
          title: Text(title,style: TextStyle(
              decoration: isDone ? TextDecoration.none : null,
              color: isDone
                  ? Colors.red
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd MMM yyyy . hh:mm a').format(createdAt),
                style: TextStyle(color: Colors.grey,fontSize: 12,
                ),
              ),
              if(dueDate != null)
                Text("📅 Due: ${DateFormat('dd MMM yyyy • hh:mm a').format(dueDate!)}",
                  style: TextStyle(color: dueDate!.isBefore(DateTime.now())
                      ? Colors.red
                      : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: onFavorite,
                  icon: Icon(isFavorite
                      ? Icons.star
                      : Icons.star_border,
                    color: Colors.amber,
                  )),
              IconButton(onPressed: onEdit, icon: Icon(Icons.edit,color: Colors.blue,)),
              IconButton(onPressed: onDelete, icon: Icon(Icons.delete,color: Colors.red,))
            ],
          ),
        ),
      ),
    );
  }
}
