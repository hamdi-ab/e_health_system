import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String? profilePicture;

  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    this.profilePicture,
  });

  @override
  List<Object> get props => [firstName, lastName, email, phone, address, gender];
} 