import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String username;
  final String message;
  final DateTime datetime;

  MessageTile({
    required this.username,
    required this.message,
    required this.datetime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing: Text(
        DateFormat('hh:mm a').format(datetime),
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
