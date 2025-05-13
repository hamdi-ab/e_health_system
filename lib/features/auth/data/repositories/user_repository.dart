import '../../../../models/user.dart';
import '../../../../shared/enums/gender.dart';
import '../../../../shared/enums/role.dart' show Role;

class UserRepository {
  Future<List<User>> fetchAllUsers() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulated network delay

    return mockUsers;
  }

  /// Fetches the current user (first one in the list for simulation purposes).
  Future<User> fetchCurrentUser() async {
    final users = await fetchAllUsers();
    return users.firstWhere(
      (user) => user.userId == "user1",
      orElse: () => throw Exception("User not found"),
    );
  }
}

List<User> mockUsers = [
  // Doctor 1 (Existing)
  User(
    userId: "user1",
    auth0Id: "auth0_sample_id",
    auth0AccessToken: "sample_access_token",
    auth0RefreshToken: "sample_refresh_token",
    firstName: "Hamdi",
    lastName: "Ahmed",
    email: "hamdi@example.com",
    isEmailVerified: true,
    otp: null,
    phone: "+251912345678",
    gender: Gender.Male,
    dateOfBirth: DateTime(1995, 8, 21),
    profilePicture: "https://example.com/profile.jpg",
    address: "Addis Ababa, Ethiopia",
    role: Role.Doctor,
  ),

  // Doctor 2 (New)
  User(
    userId: "user2",
    auth0Id: "auth0_sample_id_2",
    auth0AccessToken: "sample_access_token_2",
    auth0RefreshToken: "sample_refresh_token_2",
    firstName: "Sophia",
    lastName: "Williams",
    email: "s.williams@hospital.com",
    isEmailVerified: true,
    otp: null,
    phone: "+1234567899",
    gender: Gender.Female,
    dateOfBirth: DateTime(1982, 3, 12),
    profilePicture: "https://example.com/profile2.jpg",
    address: "Los Angeles, USA",
    role: Role.Doctor,
  ),

  // Patient 1 (New)
  User(
    userId: "user3",
    auth0Id: "auth0_sample_id_3",
    auth0AccessToken: "sample_access_token_3",
    auth0RefreshToken: "sample_refresh_token_3",
    firstName: "Ali",
    lastName: "Khan",
    email: "ali.khan@patient.com",
    isEmailVerified: true,
    otp: null,
    phone: "+447700123456",
    gender: Gender.Male,
    dateOfBirth: DateTime(1992, 6, 5),
    profilePicture: "https://example.com/profile3.jpg",
    address: "London, UK",
    role: Role.Patient,
  ),

  // Patient 2 (New)
  User(
    userId: "user4",
    auth0Id: "auth0_sample_id_4",
    auth0AccessToken: "sample_access_token_4",
    auth0RefreshToken: "sample_refresh_token_4",
    firstName: "Aisha",
    lastName: "Mohammed",
    email: "aisha.mohammed@patient.com",
    isEmailVerified: true,
    otp: null,
    phone: "+919800234567",
    gender: Gender.Female,
    dateOfBirth: DateTime(1998, 11, 30),
    profilePicture: "https://example.com/profile4.jpg",
    address: "Mumbai, India",
    role: Role.Patient,
  ),
];
