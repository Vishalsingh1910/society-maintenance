import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/profile_service.dart';
import '../services/rbac_service.dart';

/// Admin-only endpoint for user management and role assignment.
/// All methods require admin role.
class AdminEndpoint extends Endpoint {
  /// Lists all user profiles in the system.
  /// Returns profiles ordered by creation date (newest first).
  /// 
  /// Admin only.
  /// Requires authentication and admin role.
  Future<List<UserProfile>> listUsers(Session session) async {
    // Require admin role
    await session.requireAdmin();
    
    return await ProfileService.listAllProfiles(session);
  }

  /// Sets a user's role.
  /// Allows admins to promote/demote users to different roles.
  /// 
  /// Parameters:
  /// - userId: The UUID of the user whose role should be changed
  /// - newRole: The new role to assign (admin, resident, guard, or staff)
  /// 
  /// Returns the updated user profile.
  /// 
  /// Admin only.
  /// Requires authentication and admin role.
  Future<UserProfile> setUserRole(
    Session session,
    String userId,
    UserRole newRole,
  ) async {
    // Require admin role
    await session.requireAdmin();
    
    // Parse userId string to UuidValue
    final userIdUuid = UuidValue.fromString(userId);
    
    return await ProfileService.setUserRole(
      session,
      userId: userIdUuid,
      newRole: newRole,
    );
  }
}
