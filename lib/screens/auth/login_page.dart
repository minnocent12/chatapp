import 'package:flutter/material.dart';
import 'register_page.dart';
import '../home_page.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool isLoading = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      bool success = await AuthService.login(email, password);
      setState(() => isLoading = false);

      if (success) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.isEmpty ? "Enter password" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: login, child: Text("Login")),
              TextButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RegisterPage())),
                child: Text("Don't have an account? Register here"),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
