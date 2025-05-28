import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;


  void _showBanner(String message){
    ScaffoldMessenger.of(context).clearMaterialBanners();
    final banner = MaterialBanner(
      content: Text(message),
      leading: Icon(Icons.error_outline, color: Colors.red,), 
      backgroundColor: Colors.blueGrey,
      actions: [
        TextButton(
          onPressed: (){
            ScaffoldMessenger.of(context).clearMaterialBanners();
          }, 
          child: Text("DISMISS", style: TextStyle(color: Colors.amber),)
        ),
      ],
      padding: EdgeInsets.all(16),
      );
      ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  void _login(){
    final englishMode = Provider.of<LanguageProv>(context, listen: false).currentLanguage == "en";
    final userProvider= Provider.of<User>(context, listen: false);
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
        final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white,),
              SizedBox(width: 10,),
              Expanded(child: Text(englishMode? "Email and password cannot be empty" : "Email dan password tidak boleh kosong")),
            ],
          ),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } 

      try {
      userProvider.getUserLogin(email);
      final userData = userProvider.currentUser[1];

      if (userData[2].toString() == password){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        _showBanner(englishMode? "Incorrect Password" : "Password salah");
      }
    } catch (e) {
      _showBanner(englishMode? "Email not found" : "Email tidak ditemukan");
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,

            decoration: BoxDecoration(
              color: Color(0xFF11212D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    enLang ? "Login" : "Masuk",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.grey,
                    style: TextStyle(color: Colors.black),
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFCCD0CF),
                      hintText: "email",
                      hintStyle: TextStyle(color: Color(0xFF808080)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFCCD0CF),
                      hintText: enLang ? "password" : "kata sandi",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Color(0xFF808080),
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Color(0xFF808080)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(enLang ? "Login" : "Masuk"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    enLang ? "or sign up with" : "atau daftar dengan",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFCCD0CF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            final snackbar = SnackBar(
                            content: Row( children: [
                              Icon(Icons.notifications_active,color: const Color.fromARGB(255, 75, 74, 74),),
                              SizedBox(width: 10,),
                              Text(
                                enLang ? "Sign up for Google coming soon!" : "Daftar dengan Google segerah hadir!"
                              ),
                            ]
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.deepOrangeAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          },
                          icon: Image.network(
                            'https://cdn-icons-png.flaticon.com/128/281/281764.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFCCD0CF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            final snackbar = SnackBar(
                            content: Row( children: [
                              Icon(Icons.notifications_active,color: const Color.fromARGB(255, 75, 74, 74),),
                              SizedBox(width: 10,),
                              Text(
                                enLang ? "Sign up for Facebook coming soon!" : "Daftar dengan Facebook segerah hadir!"
                              ),
                            ]
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.deepOrangeAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          },
                          icon: Image.network(
                            'https://cdn-icons-png.flaticon.com/128/5968/5968764.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFCCD0CF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            final snackbar = SnackBar(
                            content: Row( children: [
                              Icon(Icons.notifications_active,color: const Color.fromARGB(255, 75, 74, 74),),
                              SizedBox(width: 10,),
                              Text(
                                enLang ? "Sign up for Apple coming soon!" : "Daftar dengan Apple segerah hadir!"
                              ),
                            ]
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.deepOrangeAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          },
                          icon: Image.network(
                            'https://cdn-icons-png.flaticon.com/128/0/747.png',
                              width: 25,
                              height: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white, thickness: 2),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        enLang
                            ? "or don't have an account yet?"
                            : "atau belum memiliki akun?",
                      ),
                      SizedBox(width: 0),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          enLang ? "Register" : "Daftar",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
