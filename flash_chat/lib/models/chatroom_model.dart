class ChatroomModel {
  final String id;
  final List<String> usersId;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final String lastMessage;

  ChatroomModel({
    required this.id,
    required this.usersId,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usersId': usersId,
      'lastMessageTime': lastMessageTime,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessage': lastMessage
    };
  }

  factory ChatroomModel.fromMap(Map<String, dynamic> json) {
    return ChatroomModel(
      id: json['id'] as String,
      usersId: json['usersId'] as List<String>,
      lastMessageSenderId: json['lastMessageSenderId'] as String,
      lastMessageTime: json['lastMessageTime'] as DateTime,
      lastMessage: json['lastMessage'] as String,
    );
  }
}
