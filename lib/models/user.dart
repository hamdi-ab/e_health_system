import '../shared/enums/gender.dart';
import '../shared/enums/role.dart';

class User {
  final String userId;
  final String? auth0Id;
  final String? auth0AccessToken;
  final String? auth0RefreshToken;
  final String firstName;
  final String lastName;
  final String email;
  final bool isEmailVerified;
  final int? otp;
  final String phone;
  final Gender gender;
  final DateTime dateOfBirth;
  final String? profilePicture;
  final String address;
  final Role role;

  User({
    required this.userId,
    this.auth0Id,
    this.auth0AccessToken,
    this.auth0RefreshToken,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    this.otp,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    this.profilePicture,
    required this.address,
    required this.role,
  });

  // Convert JSON to User model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      auth0Id: json['auth0Id'],
      auth0AccessToken: json['auth0AccessToken'],
      auth0RefreshToken: json['auth0RefreshToken'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      otp: json['otp'],
      phone: json['phone'],
      gender: Gender.values.firstWhere(
        (e) => e.toString().split('.').last == json['gender'],
        orElse: () => Gender.Other, // Default case
      ),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      profilePicture: json['profilePicture'],
      address: json['address'],
      role: Role.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => Role.Patient, // Default case
      ),
    );
  }

  // Convert User model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'auth0Id': auth0Id,
      'auth0AccessToken': auth0AccessToken,
      'auth0RefreshToken': auth0RefreshToken,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'otp': otp,
      'phone': phone,
      'gender': gender.toString().split('.').last,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'profilePicture': profilePicture,
      'address': address,
      'role': role.toString().split('.').last,
    };
  }
}
