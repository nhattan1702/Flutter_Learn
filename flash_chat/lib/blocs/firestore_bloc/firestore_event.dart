import 'package:equatable/equatable.dart';

abstract class FirestoreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessageEvent extends FirestoreEvent {
  final String messageText;
  final String senderEmail;
  final String receiverEmail;

  SendMessageEvent({
    required this.messageText,
    required this.senderEmail,
    required this.receiverEmail,
  });

  @override
  List<Object> get props => [messageText, senderEmail, receiverEmail];
}

class GetMessagesEvent extends FirestoreEvent {
  final String currentUserEmail;
  final String otherUserEmail;

  GetMessagesEvent({
    required this.currentUserEmail,
    required this.otherUserEmail,
  });

  @override
  List<Object> get props => [currentUserEmail, otherUserEmail];
}

class SendOTPEvent extends FirestoreEvent {
  final String phoneNumber;

  SendOTPEvent({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOTPEvent extends FirestoreEvent {
  final String verificationId;
  final String smsCode;

  VerifyOTPEvent({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [verificationId, smsCode];
}

class GetUsersEvent extends FirestoreEvent {}
