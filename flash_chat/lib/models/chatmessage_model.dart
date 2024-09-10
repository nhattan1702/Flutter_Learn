class ChatMessageModel {
  final String message;
  final String sender;
  final String receiver;
  final DateTime time;
  final String chatId;

  ChatMessageModel(
      {required this.message,
      required this.sender,
      required this.time,
      required this.receiver,
      required this.chatId});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': sender,
      'time': time,
      'receiveId': receiver,
      'chatId': chatId
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> json) {
    return ChatMessageModel(
      message: json['message'] as String,
      sender: json['sender'] as String,
      time: json['time'] as DateTime,
      receiver: json['receive'] as String,
      chatId: json['chatId'] as String,
    );
  }
}
