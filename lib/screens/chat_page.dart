import 'package:chatapp/models/message_model.dart';
import 'package:flutter/material.dart';
import '../widgets/message_tile.dart';
import '../services/database_service.dart';

class ChatPage extends StatefulWidget {
  final String boardId;
  final String boardName;
  final String boardIcon; // Add board icon path as a parameter

  ChatPage(
      {required this.boardId,
      required this.boardName,
      required this.boardIcon});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // Fetch the logged-in user's first name
  Future<String> getCurrentUserFirstName() async {
    final user = await DatabaseService.getCurrentUserDetails();
    return user['firstName'] ??
        'Unknown'; // Fallback to 'Unknown' if no name exists
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final firstName = await getCurrentUserFirstName(); // Get first name
      await DatabaseService.sendMessage(
        boardId: widget.boardId,
        text: _messageController.text.trim(),
        username: firstName, // Use the actual username (first name)
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(
          children: [
            // Image corresponding to the board
            Image.asset(
              widget.boardIcon, // This is the image you want to display
              height: 30, // Adjust the height as needed
              width: 30, // Adjust the width as needed
            ),
            SizedBox(width: 10), // Space between the image and the text
            Text(
              widget.boardName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          // You can add more actions here if necessary
        ],
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: DatabaseService.getMessages(widget.boardId),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  reverse: true, // Show the latest messages at the bottom
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    return MessageTile(
                      username: message.username,
                      message: message.text,
                      datetime: message.datetime,
                    );
                  },
                );
              },
            ),
          ),
          // Message input area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Message input field with styling
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                // Send button with styling
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.deepPurpleAccent,
                    size: 30,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
