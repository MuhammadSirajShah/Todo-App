import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Screens/signup_screen.dart';
import 'package:todo_app/Services/auth_service.dart';

import '../Providers/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async{
    try{

      setState(() {
        isLoading = true;
      });
      await AuthService().login(
          emailController.text.trim(),
          passwordController.text.trim()
      );
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(),
      )
      );
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Login Failed"),
        )
      );
    } finally {
      if (mounted){
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Theme.of(context).appBarTheme.foregroundColor),
        )
        ),
        automaticallyImplyLeading: false,

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
              : themeProvider.lightGradient
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock,size: 90,),
                SizedBox(height: 30,),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black
                      )
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black
                      )
                    )
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black
                      )
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                            obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        ),
                        onPressed: (){
                          setState(() {
                            obscurePassword = !obscurePassword;
                          }
                          );
                        },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      )
                    )
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                  child: isLoading ? CircularProgressIndicator() : Text("Login",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen(),
                  ),
                  );
                }, child: Text("Don't have an account? Sign Up"))
            ],
          ),
        ),
        ),
      ),
    );
  }
}
