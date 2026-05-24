import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/Widgets/todo_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<TodoProvider>();

    final controller = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Todo App",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter Todo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: (){
                  context.read<TodoProvider>().addTodo(controller.text);
                  controller.clear();
                }, child: Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: provider.todos.length,
                itemBuilder: (context,index){
              final todo = provider.todos[index];
              return TodoTile(
                  title: todo.title,
                  isDone: todo.isDone,

                  onDelete: (){
                    context
                        .read<TodoProvider>()
                        .deleteTodo(index);
                  },
                  onToggle: (){
                    context
                        .read<TodoProvider>()
                        .toggleTodo(index);
                  },
                  );
            }
            ),
          )
        ],
      ),
    );
  }
}
