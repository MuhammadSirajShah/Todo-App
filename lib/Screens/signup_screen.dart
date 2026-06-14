import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/theme_provider.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Screens/login_screen.dart';
import 'package:todo_app/Services/auth_service.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> signUp() async{
    try{
      setState(() {
        isLoading = true;
      });
      await AuthService().signUp(
          emailController.text.trim(),
          passwordController.text.trim(),
      );
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account Created Successfully"),
        )
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()
      ));
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Failed"),
        )
      );
    } finally{
      if(mounted){
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
        //backgroundColor: Colors.teal,
        title: Center(child: Text("Sign Up",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Theme.of(context).appBarTheme.foregroundColor),),
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
              : themeProvider.lightGradient,
          ),
        ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add,size: 90,),
              SizedBox(height: 30,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )
                  ),
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
                          });
                        },),
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
                SizedBox(height: 25,),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed:  isLoading ? null : signUp,
                      child:isLoading ? CircularProgressIndicator() : Text("Create Account",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),)
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }, child:Text("Already have an account? Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
