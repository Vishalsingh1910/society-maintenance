import 'package:societymaintenance_client/societymaintenance_client.dart';
import '../main.dart';

/// Service for managing user profiles on the client side
/// Handles profile fetching, caching, and updates
class ProfileService {
  UserProfile? _cachedProfile;

  /// Gets the current user's profile from the server
  /// Automatically creates a profile if it doesn't exist (server-side)
  /// Caches the result for subsequent calls
  Future<UserProfile> getMyProfile({bool forceRefresh = false}) async {
    if (_cachedProfile != null && !forceRefresh) {
      return _cachedProfile!;
    }

    try {
      final profile = await client.profile.getMyProfile();
      _cachedProfile = profile;
      return profile;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  /// Updates the current user's profile
  /// Clears cache to force refresh on next get
  Future<UserProfile> updateMyProfile({
    required String fullName,
    String? phone,
  }) async {
    try {
      final updatedProfile = await client.profile.updateMyProfile(
        fullName,
        phone,
      );
      _cachedProfile = updatedProfile;
      return updatedProfile;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Clears the cached profile
  /// Call this after logout or when you want to force a refresh
  void clearCache() {
    _cachedProfile = null;
  }

  /// Gets the cached profile without making a server call
  /// Returns null if no profile is cached
  UserProfile? get cachedProfile => _cachedProfile;

  /// Checks if a profile is cached
  bool get hasCache => _cachedProfile != null;
}
