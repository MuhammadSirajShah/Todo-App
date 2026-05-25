import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/Widgets/todo_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = TextEditingController();
    final provider = context.watch<TodoProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Todo App",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter Todo",
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: () {
                  context.read<TodoProvider>().addTodo(controller.text);
                  controller.clear();
                },
                    child: Text("add",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueGrey),))
              ],
            ),
          ),
          Expanded(
            child: provider.todos.isEmpty
                ? Center(child: Text("No Todo Yet",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey,
            ),
            ),
            )
                : ListView.builder(
                itemCount: provider.todos.length,
                itemBuilder: (context , index){
                  final todo = provider.todos[index];
                  return TodoTile(
                      title: todo.title,
                      isDone: todo.isDone,
                      onDelete: (){
                        context.read<TodoProvider>().deleteTodo(index);
                      },
                      onToggle: (){
                        context.read<TodoProvider>().toggleTodo(index);
                      }


                  );
                })
          )
        ],
      ),
    );
  }
}
