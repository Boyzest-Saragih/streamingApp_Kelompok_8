import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/complete_profile/complete_profile.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/screens/login_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usenameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscurePass = true;
  bool _isObscureConfirmPass = true;
  bool checkBox = false;

  void _register() {
    final user = Provider.of<User>(context,listen: false);
    String email = _emailController.text;
    String username = _usenameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isNotEmpty || username.isNotEmpty || password.isNotEmpty||password==confirmPassword) {
      user.addUser(email, username, password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompleteProfile()),
      );
    }
    user.getUserLogin(email);
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                obscureText: _isObscurePass,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCCD0CF),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Color(0xFF808080)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePass ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF808080),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscurePass = !_isObscurePass;
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
                obscureText: _isObscureConfirmPass,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCCD0CF),
                  hintText: "Confirm Password",
                  hintStyle: TextStyle(color: Color(0xFF808080)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirmPass
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Color(0xFF808080),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmPass = !_isObscureConfirmPass;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CheckboxListTile(
                activeColor: Colors.amber,
                title: Text(
                  "i agree to thr Terms of Services and Privacy Policy",
                  style: TextStyle(fontSize: 11),
                ),
                value: checkBox,
                onChanged: (bool? newValue) {
                  setState(() {
                    checkBox = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: checkBox ? _register : null,
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
                  const Text("or already have an account?"),
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
