import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/theme_provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/Services/auth_service.dart';
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

  @override
  void dispose() {
    controller.dispose();
    editController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Todo App",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Theme
              .of(context)
              .appBarTheme
              .foregroundColor),
        ),
        ),
        actions: [
          Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
            return IconButton(onPressed: () {
              themeProvider.toggleTheme();
            }, icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme
                  .of(context)
                  .appBarTheme
                  .foregroundColor,

            ),
            );
          }
          ),
          IconButton(onPressed: ()async{
            await AuthService().logout();
          }, icon: Icon(Icons.logout))
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
        
                    SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isEmpty) return;

                          final newTodo = controller.text;
                          context.read<TodoProvider>().addTodo(newTodo);
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
                                ))
                          );
                          controller.clear();
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("Total Todo: ${provider.todos.length}",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Theme
                      .of(context)
                      .colorScheme
                      .onSurface),),
              ),
              SizedBox(height: 10,),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) {
                    context.read<TodoProvider>().searchTodos(value);
                  },
                  decoration: InputDecoration(
                      hintText: "Search Todo",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Theme
                          .of(context)
                          .cardColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  ),
                ),
              ),
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
              SizedBox(height: 10,),
              Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: provider.todos.isEmpty
                        ? (isKeyboardOpen
                          ? SizedBox()
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 160,
                                child: Lottie.asset(
                                    "assets/animations/empty.json")),
                            SizedBox(height: 15,),
                            Text("No Todo Yet",
                              style: TextStyle(fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Add your first task", style: TextStyle(fontSize: 16,
                                color: Theme
                                    .of(context)
                                    .brightness == Brightness.dark
                                    ? Colors.grey.shade400
                                    : Colors.black54
                            ),
                            ),
                          ],
                        ),
                    ))
                        : ListView.builder(
                        itemCount: provider.filteredTodos.length,
                        itemBuilder: (context, index) {
                          final todo = provider.filteredTodos[index];
                          return TodoTile(
                            title: todo.title,
                            isDone: todo.isDone,
                            createdAt: todo.createdAt,
                            onDelete: () {
                              context.read<TodoProvider>().deleteTodo(index);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                    content: Row(
                                      children: [
                                        Icon(Icons.delete,color: Colors.red,),
                                        SizedBox(width: 10,),
                                        Text("Todo deleted")
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    ),

                                  )
                              );
                            },
                            onToggle: () {
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
                            onEdit: () {
                              final editController = TextEditingController(
                                text: todo.title,
                              );

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Edit Todo", style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      content: TextField(
                                        controller: editController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme
                                              .of(context)
                                              .cardColor,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20),
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .brightness == Brightness.dark
                                                      ? Colors.grey.shade400
                                                      : Colors.black54
                                              )
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () {
                                          Navigator.pop(context);
                                        },
                                          child: Text("Cancel", style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .onSurface),),
                                        ),
                                        ElevatedButton(onPressed: () {
                                          context.read<TodoProvider>().editTodo(
                                            index, editController.text,);
                                          Navigator.pop(context);
                                          ScaffoldMessenger
                                              .of(context)
                                              .showSnackBar(
                                              SnackBar(
                                                //content: Text("Todo Updated"),
                                                behavior: SnackBarBehavior.floating,
                                                duration: Duration(seconds: 2),
                                                content: Row(
                                                  children: [
                                                    Icon(Icons.update,color: Colors.green,),
                                                    SizedBox(width: 10,),
                                                    Text("Todo Updated")
                                                  ],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(12)
                                                ),

                                              )
                                          );
                                        },
                                            child: Text("Save", style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .onSurface),))
                                      ],
                                    );
                                  }
                              );
                            },
                          );
                        }),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
