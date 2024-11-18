// chatapp/lib/screens/profile_page.dart

import 'package:chatapp/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '', lastName = '';

  void loadUserData() async {
    final user = await DatabaseService.getCurrentUserDetails();
    setState(() {
      firstName = user['firstName'];
      lastName = user['lastName'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseService.updateUserProfile({
        "firstName": firstName,
        "lastName": lastName,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Profile updated")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              initialValue: firstName,
              decoration: InputDecoration(labelText: "First Name"),
              onChanged: (value) => firstName = value,
              validator: (value) => value!.isEmpty ? "Enter first name" : null,
            ),
            TextFormField(
              initialValue: lastName,
              decoration: InputDecoration(labelText: "Last Name"),
              onChanged: (value) => lastName = value,
              validator: (value) => value!.isEmpty ? "Enter last name" : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateProfile, child: Text("Save")),
          ]),
        ),
      ),
    );
  }
}
