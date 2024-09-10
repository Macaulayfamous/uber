import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String token;
<<<<<<< HEAD
  final String userType; // Added userType field
=======
   String userType; // Added userType field
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.token,
<<<<<<< HEAD
    required this.userType, // Initialize userType
=======
    this.userType = 'normal', // Default to 'normal' if not provided
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'token': token,
      'userType': userType, // Include userType in the map
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      phone: map['phone'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
<<<<<<< HEAD
      userType: map['userType'] as String? ?? "user", // Default to "user"
=======
      userType: map['userType'] as String? ?? 'normal', // Default to 'normal'
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
