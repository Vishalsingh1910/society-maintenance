import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/announcement_service.dart';
import '../services/rbac_service.dart';

/// Endpoint for announcement management with RBAC protection.
/// Provides APIs for admins to create announcements and for all users to view them.
class AnnouncementEndpoint extends Endpoint {
  /// Creates a new announcement (Admin only).
  /// 
  /// Parameters:
  /// - title: Announcement headline
  /// - body: Full announcement description
  /// - attachmentUrl: Optional URL to attached file (image, PDF, etc.)
  /// 
  /// Returns the created announcement.
  /// 
  /// Requires authentication and admin role.
  Future<Announcement> createAnnouncement(
    Session session,
    String title,
    String body,
    String? attachmentUrl,
  ) async {
    // Require admin role
    await session.requireAdmin();

    return await AnnouncementService.createAnnouncement(
      session,
      title: title,
      body: body,
      attachmentUrl: attachmentUrl,
    );
  }

  /// Lists announcements with read/unread status for the current user.
  /// Returns announcements sorted by creation date (newest first).
  /// 
  /// Parameters:
  /// - limit: Maximum number of announcements to return (default: 20, max: 100)
  /// - offset: Number of announcements to skip for pagination (default: 0)
  /// 
  /// Returns a list of maps containing:
  /// - 'announcement': Announcement object
  /// - 'isRead': boolean indicating if current user has read it
  /// 
  /// Requires authentication.
  Future<List<Map<String, dynamic>>> listAnnouncements(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    // Require authentication (any authenticated user can list)
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    // Enforce maximum limit to prevent abuse
    final effectiveLimit = limit > 100 ? 100 : limit;

    return await AnnouncementService.listAnnouncementsWithReadStatus(
      session,
      limit: effectiveLimit,
      offset: offset,
    );
  }

  /// Gets details of a single announcement with read status.
  /// 
  /// Parameters:
  /// - announcementId: ID of the announcement to retrieve
  /// 
  /// Returns a map containing:
  /// - 'announcement': Announcement object
  /// - 'isRead': boolean indicating if current user has read it
  /// 
  /// Throws exception if announcement not found.
  /// Requires authentication.
  Future<Map<String, dynamic>> getAnnouncementDetails(
    Session session,
    int announcementId,
  ) async {
    // Require authentication
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    return await AnnouncementService.getAnnouncementWithReadStatus(
      session,
      announcementId,
    );
  }

  /// Marks an announcement as read for the current user.
  /// This operation is idempotent - calling it multiple times has no additional effect.
  /// 
  /// Parameters:
  /// - announcementId: ID of the announcement to mark as read
  /// 
  /// Returns true if successfully marked as read (or already read).
  /// Throws exception if announcement not found.
  /// Requires authentication.
  Future<bool> markAnnouncementRead(
    Session session,
    int announcementId,
  ) async {
    // Require authentication
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    return await AnnouncementService.markAnnouncementAsRead(
      session,
      announcementId,
    );
  }

  /// Gets the count of unread announcements for the current user.
  /// Useful for displaying badge counts in the UI.
  /// 
  /// Returns the number of unread announcements.
  /// Requires authentication.
  Future<int> getUnreadCount(Session session) async {
    // Require authentication
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    return await AnnouncementService.getUnreadCount(session);
  }

  /// Deletes an announcement (Admin only, optional for MVP).
  /// Also deletes all associated read records.
  /// 
  /// Parameters:
  /// - announcementId: ID of the announcement to delete
  /// 
  /// Returns true if successfully deleted.
  /// Throws exception if announcement not found.
  /// Requires authentication and admin role.
  Future<bool> deleteAnnouncement(
    Session session,
    int announcementId,
  ) async {
    // Require admin role
    await session.requireAdmin();

    return await AnnouncementService.deleteAnnouncement(
      session,
      announcementId,
    );
  }
}
