import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/profile_service.dart';

/// Endpoint for user profile management.
/// Provides APIs for users to get and update their own profiles.
class ProfileEndpoint extends Endpoint {
  /// Gets the current user's profile.
  /// Automatically creates a profile with default values if it doesn't exist.
  /// 
  /// Default values on auto-create:
  /// - role: resident
  /// - fullName: empty string (user should update)
  /// - createdAt: current timestamp
  /// 
  /// Returns the user's profile.
  /// Requires authentication.
  Future<UserProfile> getMyProfile(Session session) async {
    return await ProfileService.getOrCreateProfile(session);
  }

  /// Updates the current user's profile.
  /// Users can only update their own fullName and phone.
  /// Role cannot be changed through this endpoint (admin-only operation).
  /// 
  /// Parameters:
  /// - fullName: The user's full name
  /// - phone: Optional phone number
  /// 
  /// Returns the updated profile.
  /// Requires authentication.
  Future<UserProfile> updateMyProfile(
    Session session,
    String fullName,
    String? phone,
  ) async {
    return await ProfileService.updateProfile(
      session,
      fullName: fullName,
      phone: phone,
    );
  }
}
