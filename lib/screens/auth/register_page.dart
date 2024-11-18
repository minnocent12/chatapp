import 'package:flutter/material.dart';
import '../home_page.dart';
import '../../services/auth_service.dart';
import 'package:validators/validators.dart'; // Package for email validation

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', firstName = '', lastName = '';
  bool isLoading = false;
  String emailErrorMessage = ''; // To display email error

  // Check if password is strong enough
  bool isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
            .hasMatch(password);
  }

  // Check if email is already in use
  Future<String?> checkEmailInUse(String email) async {
    try {
      final signInMethods =
          await AuthService.checkEmailExistence(email); // Use the public method
      if (signInMethods.isNotEmpty) {
        return "This email is already in use";
      }
    } catch (e) {
      return "Failed to check email availability";
    }
    return null;
  }

  // Register function
  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Check if the email is already in use before proceeding
      String? emailError = await checkEmailInUse(email);
      if (emailError != null) {
        setState(() {
          emailErrorMessage = emailError; // Show the email error message
        });
        setState(() => isLoading = false);
        return;
      }

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

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    } else if (!isEmail(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    } else if (!isStrongPassword(value)) {
      return "Password must be at least 8 characters,\ncontain uppercase, lowercase,\na number, and a special character.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 39, 17, 89),
              const Color.fromARGB(193, 79, 14, 34)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "First Name",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: Icon(Icons.person,
                            color: const Color.fromARGB(255, 198, 33, 243)),
                      ),
                      style: TextStyle(
                          color: Colors.white), // Text color set to white
                      onChanged: (value) => firstName = value,
                      validator: (value) =>
                          value!.isEmpty ? "Enter first name" : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: Icon(Icons.person,
                            color: const Color.fromARGB(255, 198, 33, 243)),
                      ),
                      style: TextStyle(
                          color: Colors.white), // Text color set to white
                      onChanged: (value) => lastName = value,
                      validator: (value) =>
                          value!.isEmpty ? "Enter last name" : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: Icon(Icons.email,
                            color: const Color.fromARGB(255, 198, 33, 243)),
                      ),
                      style: TextStyle(
                          color: Colors.white), // Text color set to white
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => email = value,
                      validator: validateEmail,
                    ),
                    SizedBox(height: 10),
                    if (emailErrorMessage.isNotEmpty)
                      Text(
                        emailErrorMessage,
                        style: TextStyle(
                            color: Colors
                                .white, // Error message color set to white
                            fontSize: 14),
                      ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: Icon(Icons.lock,
                            color: const Color.fromARGB(255, 198, 33, 243)),
                      ),
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.white), // Text color set to white
                      onChanged: (value) => password = value,
                      validator: validatePassword,
                    ),
                    SizedBox(height: 30),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 200, 142, 244),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
