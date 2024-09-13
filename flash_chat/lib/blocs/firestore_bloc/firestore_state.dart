import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreState extends Equatable {
  @override
  List<Object> get props => [];
}

class FirestoreInitial extends FirestoreState {}

class FirestoreLoading extends FirestoreState {}

class FirestoreMessageSent extends FirestoreState {}

class FirestoreMessagesLoaded extends FirestoreState {
  final List<QueryDocumentSnapshot> messages;

  FirestoreMessagesLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class FirestoreOTPVerified extends FirestoreState {}

class FirestoreOTPFailed extends FirestoreState {}

class FirestoreUsersLoaded extends FirestoreState {
  final List<Map<String, dynamic>> users;

  FirestoreUsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class FirestoreError extends FirestoreState {
  final String message;

  FirestoreError({required this.message});

  @override
  List<Object> get props => [message];
}
