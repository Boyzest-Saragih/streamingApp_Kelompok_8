import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/complete_profile/complete_profile.dart';
import 'package:flutter_fe/screens/login_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscurePass = true;
  bool _isObscureConfirmPass = true;
  bool checkBox = false;

  void _register() {
    final englishMode =
        Provider.of<LanguageProv>(context, listen: false).currentLanguage ==
        "en";
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    String? errorMessage;

    if (email.isEmpty) {
      errorMessage =
          englishMode ? "Please enter your email" : "Silahkan isi email anda";
    } else if (username.isEmpty) {
      errorMessage =
          englishMode
              ? "Please enter your username"
              : "Silahkan isi nama pengguna anda";
    } else if (password.isEmpty) {
      errorMessage =
          englishMode
              ? "Please enter your password"
              : "Silahkan isi kata sandi anda";
    } else if (confirmPassword.isEmpty) {
      errorMessage =
          englishMode
              ? "Please confirm your password"
              : "Silahkan konfirmasi kata sandi anda";
    } else if (password != confirmPassword) {
      errorMessage =
          englishMode ? "Password do not match" : "Kata sandi tidak cocok";
    }

    if (errorMessage != null) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text(errorMessage)),
          ],
        ),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    _showConfirmationDialog(email, username, password);
  }

  void _showConfirmationDialog(String email, String username, String password) {
    final englishMode =
        Provider.of<LanguageProv>(context, listen: false).currentLanguage ==
        "en";
    final user = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          title: Text(
            textAlign: TextAlign.center,
            englishMode ? "Confirm Email?" : "Konfirmasi Email?",
            style: TextStyle(color: Colors.grey),
          ),
          content: SizedBox(
            width: 150,
            height: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  englishMode
                      ? "Is Your Email Correct?"
                      : "Apakah Email Anda sudah benar?",
                ),
                Text(" $email"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(englishMode ? "No" : "Tidak"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                user.addUser(
                  email: email,
                  username: username,
                  password: password,
                  gender: "",
                  genres: [""],
                  birthDate: DateTime(2000, 1, 1),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompleteProfile()),
                );
                user.getUserLogin(email);
              },
              child: Text(englishMode ? "Yes" : "Ya"),
            ),
          ],
          backgroundColor: Color(0xFF11212D),
        );
      },
    );
  }

  // if (email.isNotEmpty &&
  //     username.isNotEmpty &&
  //     password.isNotEmpty &&
  //     password == confirmPassword) {
  //   user.addUser(email, username, password);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => CompleteProfile()),
  //   );
  // } else {
  //   final snackBar = SnackBar(
  //     content: Row(
  //       children: [
  //         Icon(Icons.warning, color:  Colors.white),
  //         SizedBox(width: 10,),
  //         Expanded(child: Text("Isi Semua Data "))

  //       ],
  //     ),
  //     behavior: SnackBarBehavior.floating,
  //     duration: Duration(seconds: 3),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  // user.getUserLogin(email);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                    enLang ? "Register" : "Daftar",
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
                    prefixIcon: Icon(Icons.mail, color: Colors.grey),
                    hintText: "Email",
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
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFCCD0CF),
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    hintText: enLang ? "Username" : "Nama Pengguna",
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
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: enLang ? "Password" : "kata sandi",
                    hintStyle: TextStyle(color: Color(0xFF808080)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscurePass
                            ? Icons.visibility_off
                            : Icons.visibility,
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
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText:
                        enLang ? "Confirm Password" : "konfirmasi kata sandi",
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
                    enLang
                        ? "i agree to the Terms of Services and Privacy Policy"
                        : "saya setuju dengan syarat dan ketentuan layanan dan kebijakan privasi",
                    style: TextStyle(fontSize: 11, color: Colors.white),
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
                  child: Text(
                    enLang ? "Sign Up" : "Daftar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                            content: Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: const Color.fromARGB(255, 75, 74, 74),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  enLang
                                      ? "Sign up for Google coming soon!"
                                      : "Daftar dengan Goggle segerah hadir!",
                                ),
                              ],
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.deepOrangeAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                            content: Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: const Color.fromARGB(255, 75, 74, 74),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  enLang
                                      ? "Sign up for Facebook coming soon!"
                                      : "Daftar dengan Facebook segerah hadir!",
                                ),
                              ],
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.deepOrangeAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                            content: Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: const Color.fromARGB(255, 75, 74, 74),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  enLang
                                      ? "Sign up for Apple coming soon!"
                                      : "Daftar dengan Apple segerah hadir!",
                                ),
                              ],
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.deepOrangeAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                Divider(color: Colors.white, thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      enLang
                          ? "or already have an account?"
                          : "atau sudah memiliki akun?",
                    ),
                    SizedBox(width: 0),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        enLang ? "Login" : "Masuk",
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
