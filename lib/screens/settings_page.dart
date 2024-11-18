// chatapp/lib/screens/settings_page.dart

import 'package:chatapp/screens/auth/login_page.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsPage extends StatelessWidget {
  void logout(BuildContext context) async {
    await AuthService.logout();
    // Replaces the current route and removes all previous routes, leading to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Ensure you have LoginPage
      (route) => false, // This removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false, // This removes all previous routes
            ); // Go back to the Home screen
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Logout"),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
