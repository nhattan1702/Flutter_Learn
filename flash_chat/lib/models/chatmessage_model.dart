class ChatmessageModel {
  final String id;
  final String message;
  final String senderId;
  final DateTime time;

  ChatmessageModel({
    required this.id,
    required this.message,
    required this.senderId,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'message': message, 'senderId': senderId, 'time': time};
  }

  factory ChatmessageModel.fromMap(Map<String, dynamic> json) {
    return ChatmessageModel(
      id: json['id'] as String,
      message: json['message'] as String,
      senderId: json['senderId'] as String,
      time: json['time'] as DateTime,
    );
  }
}
