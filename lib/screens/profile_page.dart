import 'package:chatapp/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>(); // Key for the password form

  // Controllers for the TextFormFields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController currentPasswordController =
      TextEditingController(); // Controller for current password
  TextEditingController newPasswordController =
      TextEditingController(); // Controller for new password

  // Method to load the user data from Firestore
  void loadUserData() async {
    final user = await DatabaseService.getCurrentUserDetails();
    setState(() {
      // Update controllers with fetched data
      firstNameController.text = user['firstName'] ?? '';
      lastNameController.text = user['lastName'] ?? '';
      emailController.text = user['email'] ?? ''; // Load email as well
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data on page load
  }

  @override
  void dispose() {
    // Don't forget to dispose the controllers when the page is destroyed
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  // Method to update the user profile data
  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseService.updateUserProfile({
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text, // Save the updated email
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Profile updated")));
    }
  }

  // Validate password strength
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your new password";
    } else if (value.length < 8 ||
        !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])')
            .hasMatch(value)) {
      return "Password must be at least 8 characters,\ncontain uppercase, lowercase,\na number, and a special character.";
    }
    return null;
  }

  // Method to update the user's password
  void updatePassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      final currentPassword = currentPasswordController.text;
      final newPassword = newPasswordController.text;

      try {
        // Re-authenticate the user with the current password
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the password if the re-authentication is successful
        await user.updatePassword(newPassword);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password updated successfully")));
        currentPasswordController.clear();
        newPasswordController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true, // App bar extends behind the body
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 39, 17, 89),
              const Color.fromARGB(193, 79, 14, 34),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Profile Icon Section
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromARGB(0, 150, 19, 189),
                  child: Icon(
                    Icons.account_circle,
                    size: 80,
                    color: const Color.fromARGB(
                        255, 227, 226, 230), // Matching color
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Profile Form Fields Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // First Name Field
                        TextFormField(
                          controller: firstNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(color: Colors.white), // White error messages
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter first name" : null,
                        ),
                        SizedBox(height: 16),

                        // Last Name Field
                        TextFormField(
                          controller: lastNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(color: Colors.white), // White error messages
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter last name" : null,
                        ),
                        SizedBox(height: 16),

                        // Email Field
                        TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(color: Colors.white), // White error messages
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter email" : null,
                        ),
                        SizedBox(height: 20),

                        // Save Button for Profile
                        ElevatedButton(
                          onPressed: updateProfile,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Password Change Form
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _passwordFormKey,
                    child: Column(
                      children: [
                        // Current Password Field
                        TextFormField(
                          controller: currentPasswordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Current Password",
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(color: Colors.white), // White error messages
                          ),
                        ),
                        SizedBox(height: 16),

                        // New Password Field
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "New Password",
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(color: Colors.white), // White error messages
                          ),
                          validator: (value) => validatePassword(value),
                        ),
                        SizedBox(height: 20),

                        // Save Button for Password Change
                        ElevatedButton(
                          onPressed: updatePassword,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "Save Password",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
