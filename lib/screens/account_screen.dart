import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fe/screens/register_screen.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context);
    final user = userProvider.currentUser;

    if (user.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF06141B),
        body: Center(
          child: Text(
            "Tidak Ada Data User",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final data = user[1]; 

    return Scaffold(
      backgroundColor: const Color(0xFF06141B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF11212D),
        title: const Text("Account Info"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItem(Icons.email, "Email", data[0]),
            _buildItem(Icons.person, "Username", data[1]),
            _buildItem(Icons.lock, "Password", "********"),
            _buildItem(Icons.wc, "Gender", data[3]),
            _buildItem(
                Icons.movie_filter,
                "Genres",
                data[4] is List ? (data[4] as List).join(", ") : data[4].toString(),
              ),
    
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  userProvider.currentUser = [];
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle) {
    return Card(
      color: const Color(0xFF11212D),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title, style: const TextStyle(color: Colors.grey)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
