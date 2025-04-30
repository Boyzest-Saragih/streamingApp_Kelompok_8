import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                const Text(
                  "Login",
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
                    hintText: "password",
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
                ElevatedButton(onPressed: _login, child: const Text("Login")),
                SizedBox(height: 15),
                Text(
                  "or sign up with",
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
                        onPressed: () {},
                        icon: Image.asset('google.png', width: 20, height: 20),
                      ),
                    ),

                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFCCD0CF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'facebook.png',
                          width: 20,
                          height: 20,
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
                        onPressed: () {},
                        icon: Image.asset('apple.png', width: 20, height: 20),
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
                    const Text("or don't have an account yet?"),
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
                      child: const Text(
                        "register",
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
    );
  }
}
