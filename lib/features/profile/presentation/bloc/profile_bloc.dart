import 'package:e_health_system/models/user.dart';
import 'package:e_health_system/shared/enums/gender.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/data/repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await repository.fetchCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final currentUser = await repository.fetchCurrentUser();

      // Create a new user with updated fields
      final updatedUser = User(
        userId: currentUser.userId,
        auth0Id: currentUser.auth0Id,
        auth0AccessToken: currentUser.auth0AccessToken,
        auth0RefreshToken: currentUser.auth0RefreshToken,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        isEmailVerified: currentUser.isEmailVerified,
        otp: currentUser.otp,
        phone: event.phone,
        gender: event.gender == "Male" ? Gender.Male : Gender.Female,
        dateOfBirth: currentUser.dateOfBirth,
        profilePicture: event.profilePicture,
        address: event.address,
        role: currentUser.role,
      );

      await repository.updateUser(updatedUser);
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
