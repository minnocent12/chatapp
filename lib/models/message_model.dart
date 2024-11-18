// chatapp/lib/models/message_model.dart

class MessageModel {
  String text;
  String username;
  DateTime datetime;

  MessageModel(
      {required this.text, required this.username, required this.datetime});

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      text: data['text'],
      username: data['username'],
      datetime: data['datetime'].toDate(),
    );
  }
}
