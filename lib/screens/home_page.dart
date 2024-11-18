import 'package:chatapp/models/message_board_model.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import '../services/database_service.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure that the default boards are created on app startup
    DatabaseService.createDefaultMessageBoards();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Message Boards",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // App bar text color
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0, // Remove app bar shadow
        iconTheme: IconThemeData(
          color: Colors.white, // Drawer icon color
        ),
      ),
      extendBodyBehindAppBar: true, // Extend app bar over the background
      drawer: CustomNavigationDrawer(),
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
        child: FutureBuilder<List<MessageBoardModel>>(
          future: DatabaseService.getMessageBoards(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8)),
                ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No message boards available",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                top: kToolbarHeight +
                    20, // Ensure content doesn't overlap the app bar
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final board = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(board.icon),
                        radius: 25,
                      ),
                      title: Text(
                        board.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "Tap to join the conversation",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              boardId: board.id,
                              boardName: board.name,
                              boardIcon: board.icon,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
