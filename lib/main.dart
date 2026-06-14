import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/theme_provider.dart';
import 'package:todo_app/Providers/todo_provider.dart';
import 'package:todo_app/Screens/auth_wrapper.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Screens/login_screen.dart';
import 'package:todo_app/Screens/signup_screen.dart';
import 'package:todo_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal.shade300,
              foregroundColor: Colors.black54,
            )
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF121212),
            cardColor: Color(0xFF1E1E1E),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF202C33),
              foregroundColor: Colors.white,
            )
          ),
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
        );
      }),
    );
  }
}

