import 'dart:io';

class UserModel {
  final String id;
  final String email;
  final String password;
  //final File image;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
   // required this.image
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
   //   image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
  //    'image': image
    };
  }
}
