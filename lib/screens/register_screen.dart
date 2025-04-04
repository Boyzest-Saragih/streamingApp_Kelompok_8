import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usenameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  void _register() {
    String email = _emailController.text;
    String username = _usenameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua kolom harus di isi")));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password dan konfirmasi password tidak sama")),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil!")));

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06141B),
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF11212D),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                cursorColor: Colors.grey,
                style: TextStyle(color: Colors.black),
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCCD0CF),
                  hintText: "Email or phone number",
                  hintStyle: TextStyle(color: Color(0xFF808080)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                cursorColor: Colors.grey,
                style: TextStyle(color: Colors.black),
                controller: _usenameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCCD0CF),
                  hintText: "Username",
                  hintStyle: TextStyle(color: Color(0xFF808080)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                cursorColor: Colors.grey,
                style: TextStyle(color: Colors.black),
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCCD0CF),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Color(0xFF808080)),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                cursorColor: Colors.grey,
                style: TextStyle(color: Colors.black),
                controller: _confirmPasswordController,
                obscureText: _isConfirmObscure,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCCD0CF),
                  hintText: "Confirm Password",
                  hintStyle: TextStyle(color: Color(0xFF808080)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmObscure ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF808080),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmObscure = !_isConfirmObscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: const Text("Sign Up"),
              ),

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
                      icon: Image.asset('facebook.png', width: 20, height: 20),
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
              Divider(color: Colors.white, thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("or already have an account?", style: TextStyle(color: Colors.white)),
                  SizedBox(width: 0),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}