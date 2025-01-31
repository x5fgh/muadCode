import 'package:flutter/material.dart';

class User {
  final String username;
  final String email;
  final String phoneNumber;

  User({
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        email: json['email'],
        phoneNumber: json['phone_number'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'phone': phoneNumber,
      };
}

class UserProvider with ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _phoneNumber = '';
  String _email = '';
  String _password = '';
  User? _user;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get password => _password;

  User? get user => _user;

  // معلومات المستخدم
  void setUserDetails({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _phoneNumber = phoneNumber;
    _email = email;
    _password = password;
    _user = User(
      username: firstName + ' ' + lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
    notifyListeners();
  }

  void loadUserFromJson(Map<String, dynamic> json) {
    _firstName = json['firstName'] ?? '';
    _lastName = json['lastName'] ?? '';
    _phoneNumber = json['phoneNumber'] ?? '';
    _email = json['email'] ?? '';
    _password = json['password'] ?? '';
    _user = User(
      username: _firstName + ' ' + _lastName,
      email: _email,
      phoneNumber: _phoneNumber,
    );
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': _firstName,
      'lastName': _lastName,
      'phoneNumber': _phoneNumber,
      'email': _email,
      'password': _password,
      'user': _user?.toJson(),
    };
  }
}
