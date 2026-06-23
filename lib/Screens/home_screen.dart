import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Models/toto_model.dart';
import 'package:todo_app/Providers/theme_provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/Services/auth_service.dart';
import 'package:todo_app/Services/firestore_service.dart';
import 'package:todo_app/Services/notification_service.dart';
import 'package:todo_app/Widgets/filter_button.dart';
import 'package:todo_app/Widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  final TextEditingController controller = TextEditingController();
  final TextEditingController editController = TextEditingController();

  DateTime? selectedDueDate;
  bool isSearching = false;

  @override
  void dispose() {
    controller.dispose();
    editController.dispose();
    super.dispose();
  }

  Future<void> pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }



  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value){
                  context.read<TodoProvider>().searchTodos(value);
                },
          decoration: InputDecoration(
            hintText: "Search Todo",
            border: InputBorder.none,

          ),
        )
        : Center(child: Text("Todo App",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Theme
              .of(context)
              .appBarTheme
              .foregroundColor),
        ),
        ),
        actions: [
          if(!isSearching) ...[
            IconButton(onPressed: (){
              themeProvider.toggleTheme();
            }, icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
            ),
            ),
            IconButton(onPressed: (){
              setState(() {
                isSearching = true;
              });
            }, icon: Icon(Icons.search),
            ),
          ] else ...[
            IconButton(onPressed: (){
              setState(() {
                isSearching = false;
              });
              context.read<TodoProvider>().searchTodos("");
            }, icon: Icon(Icons.close)
            )
          ],
          IconButton(onPressed: ()async{
            await AuthService().logout();
          }, icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeProvider.isDarkMode
                  ? themeProvider.darkGradient
                  : themeProvider.lightGradient,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton(text: "All", filter: TodoFilter.all),
                    FilterButton(text: "Completed", filter: TodoFilter.completed),
                    FilterButton(text: "Pending", filter: TodoFilter.pending)
                  ],
                ),
              ),
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
                            fillColor: Theme
                                .of(context)
                                .cardColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .brightness == Brightness.dark
                                        ? Colors.grey.shade400
                                        : Colors.black54
                                )
                            )
                        ),
                      ),
                    ),
                    IconButton(onPressed: pickDueDate, icon: Icon(Icons.calendar_month,),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () async{
                          if (controller.text.trim().isEmpty) return;
                          if(selectedDueDate == null){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please select Due Date & Time")
                              )
                            );
                            return;
                          }

                          if(selectedDueDate!.isBefore(DateTime.now())){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please select a future time")
                              ),
                            );
                            return ;
                          }
                          final newTodo = controller.text;
                          await FirestoreService().addTodo(newTodo,selectedDueDate);
                          await NotificationService.instance.scheduleNotification(
                              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                              title: '📌 $newTodo',
                              body: "It's time to complete your task.",
                              scheduledDate: selectedDueDate!,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle,color: Colors.green),
                                    SizedBox(width: 10,),
                                    Text("Todo Added Successfully"),
                                  ],
                                )
                            )
                          );
                          controller.clear();
                          setState(() {
                            selectedDueDate = null;
                          });
                        },
                        child: Text("add", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface),))
                  ],
                ),
              ),
              if (selectedDueDate != null)
                Text("Due: ${DateFormat('dd MMM yyyy • hh:mm a').format(selectedDueDate!)}",
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 5,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirestoreService().getTodos(),
                    builder: (context , snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 160,
                                  child: Lottie.asset("assets/animations/empty.json")
                              ),
                              SizedBox(height: 15,),
                              Text("No Todo Yet",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold
                              ),
                              )
                            ],
                          ),
                        );
                      }
                      final todos = snapshot.data!.docs;

                      final filteredTodos = todos.where((todo){
                        final title = todo["title"].toString().toLowerCase();

                        final matchesSearch = title.contains(
                          provider.searchQuery.toLowerCase(),
                        );

                        bool matchesFilter = true;

                        switch (provider.currentFilter){
                          case TodoFilter.completed:
                            matchesFilter = todo["isDone"] == true;
                            break;

                          case TodoFilter.pending:
                            matchesFilter = todo["isDone"] == false;
                            break;

                          case TodoFilter.all:
                            matchesFilter = true;
                            break;
                        }

                        return matchesSearch && matchesFilter;
                      }).toList();

                      return Column(
                        children: [
                      Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("Total Todo: ${filteredTodos.length}",
                      style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Theme
                          .of(context)
                          .colorScheme
                          .onSurface
                      ),
                      ),
                      ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredTodos.length,
                              itemBuilder: (context , index){
                                final todo = filteredTodos[index];

                                return TodoTile(
                                  title: todo["title"],
                                  isDone: todo["isDone"],
                                  isFavorite: todo["isFavorite"] ?? false,
                                  createdAt: todo["createdAt"] is Timestamp
                                      ? (todo["createdAt"] as Timestamp).toDate()
                                      : DateTime.parse(todo["createdAt"]),

                                  dueDate: todo["dueDate"] == null
                                      ? null
                                      : (todo["dueDate"] as Timestamp).toDate(),


                                  onDelete: () async{
                                    final deletedTodo = TodoModel(
                                        title: todo["title"],
                                        isDone: todo["isDone"],
                                        createdAt: todo["createdAt"] is Timestamp
                                            ? (todo["createdAt"] as Timestamp).toDate()
                                            : DateTime.parse(todo["createdAt"]),
                                        dueDate: todo["dueDate"] == null
                                            ? null
                                            : (todo["dueDate"] as Timestamp).toDate(),
                                    );
                                    await FirestoreService().deleteTodo(todo.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Todo Deleted"),
                                          duration: Duration(seconds: 5),
                                          action: SnackBarAction(
                                              label: "UNDO",
                                              onPressed: () async {
                                                await FirestoreService().restoreTodo(deletedTodo);
                                              }
                                              ),
                                      )
                                    );
                                  },
                                  onToggle: ()async{
                                    await FirestoreService().toggleTodo(todo.id, todo["isDone"],
                                    );
                                  },
                                  onFavorite: () async {
                                    await FirestoreService().toggleFavorite(todo.id, todo["isFavorite"] ?? false);
                                  },

                                  onEdit: (){
                                    final editController = TextEditingController(text: todo["title"],
                                    );
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Edit Todo"),
                                            content: TextField(
                                              controller: editController,
                                            ),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, child: Text("Cancel")
                                              ),
                                              ElevatedButton(onPressed: ()async{
                                                await FirestoreService().editTodo(todo.id, editController.text);
                                                Navigator.pop(context);
                                              }, child: Text("Save"))
                                            ],
                                          );
                                        });
                                  },
                                )
                                    .animate()
                                    .fade(
                                  duration: 400.ms,
                                )
                                    .slideY(
                                  begin: -0.25,
                                  end: 0,
                                  duration: 400.ms,
                                  curve: Curves.easeOut,
                                );

                              },
                            ),
                          )
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
