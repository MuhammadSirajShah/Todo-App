import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Models/toto_model.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/Widgets/filter_button.dart';
import 'package:todo_app/Widgets/todo_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<TodoProvider>();
    final controller = TextEditingController();
    final editController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Todo App",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Colors.teal.shade200,
              Colors.white60,
              Colors.black12
            ]
          )
        ),
        child: Column(
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
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black
                            )
                          )
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed: () {
                        if(controller.text.trim().isEmpty) return;
                    context.read<TodoProvider>().addTodo(controller.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Todo Added Successfully"),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                      ),
                    );
                    controller.clear();
                  },
                      child: Text("add",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueGrey),))
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("Total Todo: ${provider.todos.length}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value){
                  context.read<TodoProvider>().searchTodos(value);
                },
                decoration: InputDecoration(
                  hintText: "Search Todo",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterButton(text: "All", filter: TodoFilter.all),
                  FilterButton(text: "Completed", filter: TodoFilter.completed),
                  FilterButton(text: "Pending", filter: TodoFilter.pending)

                ],

              ),
            ),
            SizedBox(height: 10,),
            Expanded(
                child: provider.todos.isEmpty
                    ? Center(child: Text("No Todo Yet",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey,
                ),
                ),
                )
                    : ListView.builder(
                    itemCount: provider.filteredTodos.length,
                    itemBuilder: (context , index){
                      final todo = provider.filteredTodos[index];
                      return TodoTile(
                          title: todo.title,
                          isDone: todo.isDone,
                          createdAt: todo.createdAt,
                          onDelete: (){
                            context.read<TodoProvider>().deleteTodo(index);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Todo Deleted"),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),

                              )
                            );
                          },
                          onToggle: (){
                            context.read<TodoProvider>().toggleTodo(index);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      todo.isDone
                                          ? "Todo Marked Pending"
                                          : "Todo Completed"
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),

                              )
                            );
                          },
                          onEdit: (){
                            final editController = TextEditingController(text: todo.title,
                            );

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Edit Todo",
                                    ),
                                    content: TextField(
                                      controller: editController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.black
                                          )
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("Cancel"),
                                      ),
                                      ElevatedButton(onPressed: (){
                                        context.read<TodoProvider>().editTodo(index, editController.text,
                                        );
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Todo Updated"),
                                              behavior: SnackBarBehavior.floating,
                                              duration: Duration(seconds: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)
                                              ),

                                          )
                                        );
                                      }, child: Text("Save"))
                                    ],
                                  );
                                }
                                );},
                      );
                    })
            )
          ],
        ),
      ),
      );
  }
}
