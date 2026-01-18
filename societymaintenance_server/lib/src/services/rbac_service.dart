import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'profile_service.dart';

/// RBAC (Role-Based Access Control) service for enforcing role-based permissions.
/// Provides utilities to check and require specific roles for endpoint access.
class RBACService {
  /// Requires that the current user has the specified role.
  /// Throws an exception if the user doesn't have the required role.
  /// 
  /// Usage in endpoints:
  /// ```dart
  /// await RBACService.requireRole(session, UserRole.admin);
  /// ```
  static Future<void> requireRole(Session session, UserRole requiredRole) async {
    final userRole = await ProfileService.getUserRole(session);
    
    if (userRole == null) {
      throw Exception('User not authenticated or profile not found');
    }
    
    if (userRole != requiredRole) {
      throw Exception(
        'Access denied. Required role: ${requiredRole.name}, user role: ${userRole.name}'
      );
    }
  }

  /// Requires that the current user has one of the specified roles.
  /// Throws an exception if the user doesn't have any of the required roles.
  /// 
  /// Usage in endpoints:
  /// ```dart
  /// await RBACService.requireAnyRole(session, [UserRole.admin, UserRole.staff]);
  /// ```
  static Future<void> requireAnyRole(
    Session session,
    List<UserRole> allowedRoles,
  ) async {
    final userRole = await ProfileService.getUserRole(session);
    
    if (userRole == null) {
      throw Exception('User not authenticated or profile not found');
    }
    
    if (!allowedRoles.contains(userRole)) {
      final allowedRoleNames = allowedRoles.map((r) => r.name).join(', ');
      throw Exception(
        'Access denied. Required roles: $allowedRoleNames, user role: ${userRole.name}'
      );
    }
  }

  /// Checks if the current user has the specified role.
  /// Returns true if user has the role, false otherwise.
  /// Returns false if user is not authenticated or profile doesn't exist.
  /// 
  /// Usage in endpoints:
  /// ```dart
  /// if (await RBACService.hasRole(session, UserRole.admin)) {
  ///   // Admin-specific logic
  /// }
  /// ```
  static Future<bool> hasRole(Session session, UserRole role) async {
    final userRole = await ProfileService.getUserRole(session);
    return userRole == role;
  }

  /// Checks if the current user has any of the specified roles.
  /// Returns true if user has at least one of the roles, false otherwise.
  /// Returns false if user is not authenticated or profile doesn't exist.
  static Future<bool> hasAnyRole(Session session, List<UserRole> roles) async {
    final userRole = await ProfileService.getUserRole(session);
    if (userRole == null) return false;
    return roles.contains(userRole);
  }

  /// Requires admin role. Convenience method for common use case.
  static Future<void> requireAdmin(Session session) async {
    await requireRole(session, UserRole.admin);
  }

  /// Checks if current user is an admin.
  static Future<bool> isAdmin(Session session) async {
    return await hasRole(session, UserRole.admin);
  }
}

/// Extension on Session to provide easy access to RBAC methods
extension SessionRBAC on Session {
  /// Gets the current user's role
  Future<UserRole?> get userRole => ProfileService.getUserRole(this);
  
  /// Checks if current user has the specified role
  Future<bool> hasRole(UserRole role) => RBACService.hasRole(this, role);
  
  /// Checks if current user is an admin
  Future<bool> get isAdmin => RBACService.isAdmin(this);
  
  /// Requires the specified role, throws if not authorized
  Future<void> requireRole(UserRole role) => RBACService.requireRole(this, role);
  
  /// Requires admin role, throws if not authorized
  Future<void> requireAdmin() => RBACService.requireAdmin(this);
  
  /// Requires any of the specified roles, throws if not authorized
  Future<void> requireAnyRole(List<UserRole> roles) => 
    RBACService.requireAnyRole(this, roles);
}
