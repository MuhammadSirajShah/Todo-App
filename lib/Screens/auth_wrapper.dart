import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context , snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if(snapshot.hasData){
            return HomeScreen();
          }
          return LoginScreen();
        }
    );
  }
}