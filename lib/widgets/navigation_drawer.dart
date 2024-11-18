import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';
import '../screens/settings_page.dart';
import '../services/database_service.dart';
import '../screens/auth/login_page.dart'; // Make sure to import the LoginPage
import '../services/auth_service.dart'; // Import your AuthService

class CustomNavigationDrawer extends StatelessWidget {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: DatabaseService.getCurrentUserDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width, // Full width
                    height: 200, // Adjust this based on your design
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }

                final user = snapshot.data!;
                final String firstName = user['firstName'];
                final String lastName = user['lastName'];

                return Container(
                  width: MediaQuery.of(context).size.width, // Full width
                  height: 200, // Adjust this based on your design
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Greeting text with margin to the top-left
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, left: 16.0),
                            child: Text(
                              _getGreeting(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 30), // Add space between greeting and icon

                        // Profile icon centered
                        Center(
                          child: Icon(
                            Icons.account_circle,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10), // Space between icon and name

                        // First and Last name centered
                        Center(
                          child: Text(
                            "$firstName $lastName",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.message,
                    title: "Message Boards",
                    onTap: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => HomePage())),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: "Profile",
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => ProfilePage())),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => SettingsPage())),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white54,
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                // Call the logout method from your AuthService
                await AuthService.logout();

                // Navigate to the LoginPage and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // This removes all previous routes
                );
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white.withOpacity(0.1),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
