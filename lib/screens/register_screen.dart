import 'package:flutter/material.dart';
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
  bool _isObscure = true;

  void _register() {
    String email = _emailController.text;
    String username = _usenameController.text;
    String password = _passwordController.text;

    if (email.isEmpty || username.isEmpty ||  password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom harus di isi")),
      );
      return;
    } 

    if (password.length < 6) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter")),
      );
      return;
    }

     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil! Silahkan Login")),
      );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06141B),
      appBar: AppBar(
        backgroundColor: Color(0xFF021024),
        title: Text("ZESTRID"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF11212D),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ),
              
              SizedBox(height: 20,),
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
                  )
                ),
              ),

              SizedBox(height: 10,),
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
                  )
                ),
              ),

              SizedBox(height: 10,),
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
                      _isObscure ? Icons.visibility : Icons.visibility_off,
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

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF052659),
                  minimumSize: Size(double.infinity, 50),

                ),
                child: const Text("Sign Up", style: TextStyle(color: Colors.white),),
                ),

                SizedBox(height: 15,),
                Text(
                  "or sign up with",
                  style: TextStyle(color: Colors.white, fontSize: 12,),
                
                ),

                SizedBox(height: 10,),
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
                        icon: Image.asset(
                          'google.png',
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
                        icon: Image.asset(
                          'apple.png',
                          width: 20,
                          height: 20,
                        ),
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