import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for managing user profiles with automatic creation on first access.
/// Handles profile CRUD operations and role management.
class ProfileService {
  /// Gets the user's profile, creating it automatically if it doesn't exist.
  ///
  /// Default values on auto-create:
  /// - role: UserRole.resident
  /// - fullName: empty string (should be updated by user)
  /// - createdAt: current timestamp
  ///
  /// Returns the user's profile.
  /// Throws if user is not authenticated.
  static Future<UserProfile> getOrCreateProfile(Session session) async {
    final authInfo = session.authenticated;

    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    final authUserId = UuidValue.fromString(authInfo.authId);

    // Try to find existing profile
    final existingProfile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(authUserId),
    );

    if (existingProfile != null) {
      return existingProfile;
    }

    // Auto-create profile with default values
    final newProfile = UserProfile(
      userId: authUserId,
      fullName: '', // User should update this
      phone: null,
      role: UserRole.resident, // Default role
      createdAt: DateTime.now(),
    );

    final createdProfile = await UserProfile.db.insertRow(session, newProfile);

    session.log(
      'Auto-created profile for user $authUserId with role: resident',
    );

    return createdProfile;
  }

  /// Updates the current user's profile.
  /// Users can only update their own fullName and phone.
  ///
  /// Returns the updated profile.
  /// Throws if user is not authenticated or profile doesn't exist.
  static Future<UserProfile> updateProfile(
    Session session, {
    required String fullName,
    String? phone,
  }) async {
    final authInfo = session.authenticated;

    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    final authUserId = UuidValue.fromString(authInfo.authId);

    // Get existing profile
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(authUserId),
    );

    if (profile == null) {
      throw Exception('Profile not found');
    }

    // Update only allowed fields
    profile.fullName = fullName;
    profile.phone = phone;

    final updatedProfile = await UserProfile.db.updateRow(session, profile);

    return updatedProfile;
  }

  /// Lists all user profiles in the system.
  /// Admin only - requires admin role.
  ///
  /// Returns list of all user profiles ordered by creation date.
  static Future<List<UserProfile>> listAllProfiles(Session session) async {
    // Get all profiles ordered by creation date (newest first)
    final profiles = await UserProfile.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    return profiles;
  }

  /// Sets a user's role.
  /// Admin only - requires admin role.
  ///
  /// Parameters:
  /// - userId: The UUID of the user whose role should be changed
  /// - newRole: The new role to assign
  ///
  /// Returns the updated profile.
  /// Throws if profile not found.
  static Future<UserProfile> setUserRole(
    Session session, {
    required UuidValue userId,
    required UserRole newRole,
  }) async {
    // Find the user's profile
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile == null) {
      throw Exception('User profile not found for userId: $userId');
    }

    // Update role
    profile.role = newRole;

    final updatedProfile = await UserProfile.db.updateRow(session, profile);

    session.log('Updated role for user $userId to ${newRole.name}');

    return updatedProfile;
  }

  /// Gets a user's current role.
  /// Returns null if user is not authenticated or profile doesn't exist.
  static Future<UserRole?> getUserRole(Session session) async {
    final authInfo = session.authenticated;

    if (authInfo == null) {
      return null;
    }

    final authUserId = UuidValue.fromString(authInfo.authId);

    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(authUserId),
    );

    return profile?.role;
  }
}
