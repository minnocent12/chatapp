// chatapp/lib/screens/home_page.dart

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
      appBar: AppBar(title: Text("Message Boards")),
      drawer: CustomNavigationDrawer(),
      body: FutureBuilder<List<MessageBoardModel>>(
        future: DatabaseService.getMessageBoards(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty)
            return Center(child: Text("No message boards available"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final board = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(board.icon), // Use asset image
                ),
                title: Text(board.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        boardId: board.id,
                        boardName: board.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
