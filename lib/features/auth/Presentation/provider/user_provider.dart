import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/user.dart';
import '../../data/repositories/user_repository.dart';

// First, create a provider for the repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Then, create a StateNotifierProvider to handle user data
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserRepository repository;

  UserNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final user = await repository.fetchCurrentUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
