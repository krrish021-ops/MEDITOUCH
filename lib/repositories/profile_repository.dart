// In-memory repository for user profile.
import '../models/models.dart';

class ProfileRepository {
  UserProfile _profile = UserProfile(name: 'User', onboardingComplete: false);

  UserProfile get() => _profile;

  void update(UserProfile profile) {
    _profile = profile;
  }

  bool get isOnboardingComplete => _profile.onboardingComplete;
}
