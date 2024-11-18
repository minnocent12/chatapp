// chatapp/lib/screens/chat_page.dart
import 'package:chatapp/models/message_model.dart';
import 'package:flutter/material.dart';
import '../widgets/message_tile.dart';
import '../services/database_service.dart';

class ChatPage extends StatefulWidget {
  final String boardId;
  final String boardName;

  ChatPage({required this.boardId, required this.boardName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await DatabaseService.sendMessage(
        boardId: widget.boardId,
        text: _messageController.text.trim(),
        username:
            "LoggedInUsername", // Replace with the actual username from user data
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.boardName)),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
