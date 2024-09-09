class UserModel {
  final String id;
  final String email;
  final String password;
  final String name;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String
    );
  }
}
