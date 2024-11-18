import 'package:flutter/material.dart';
import '../home_page.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', firstName = '', lastName = '';
  bool isLoading = false;

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      bool success = await AuthService.register(
        email,
        password,
        {
          "firstName": firstName,
          "lastName": lastName,
          "role": "user",
          "registrationDateTime": DateTime.now().toIso8601String(),
        },
      );
      setState(() => isLoading = false);

      if (success) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registration failed")));
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
                decoration: InputDecoration(labelText: "First Name"),
                onChanged: (value) => firstName = value,
                validator: (value) =>
                    value!.isEmpty ? "Enter first name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Last Name"),
                onChanged: (value) => lastName = value,
                validator: (value) => value!.isEmpty ? "Enter last name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.length < 6
                    ? "Password must be at least 6 characters"
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: register, child: Text("Register")),
            ]),
          ),
        ),
      ),
    );
  }
}
