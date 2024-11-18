import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginPage()));
      }
    });

    return Scaffold(
      body: Center(
          child: Text("Welcome to ChatApp", style: TextStyle(fontSize: 24))),
    );
  }
}
