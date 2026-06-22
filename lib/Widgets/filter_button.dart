import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';

class FilterButton extends StatelessWidget {

  final String text;
  final TodoFilter filter;
  const FilterButton({
    super.key,
    required this.text,
    required this.filter,

  });

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<TodoProvider>();
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
            provider.currentFilter == filter
              ? Colors.blue
              : Colors.grey,
        ),
        onPressed: (){
          context.read<TodoProvider>().changeFilter(filter);

    }, child: Text(text,style: TextStyle(
        fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black

    ),));
  }
}
