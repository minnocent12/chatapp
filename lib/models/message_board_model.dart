// chatapp/lib/models/message_board_model.dart

class MessageBoardModel {
  String id;
  String name;
  String icon;

  MessageBoardModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory MessageBoardModel.fromMap(Map<String, dynamic> data) {
    return MessageBoardModel(
      id: data['id'],
      name: data['name'],
      icon: data['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
