import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for managing announcements and read status tracking.
/// Provides business logic for creating, listing, and tracking announcements.
class AnnouncementService {
  /// Creates a new announcement (admin only).
  ///
  /// Parameters:
  /// - session: Current session (must be authenticated as admin)
  /// - title: Announcement headline
  /// - body: Full announcement description
  /// - attachmentUrl: Optional URL to attached file
  ///
  /// Returns the created announcement.
  static Future<Announcement> createAnnouncement(
    Session session, {
    required String title,
    required String body,
    String? attachmentUrl,
  }) async {
    // Get authenticated user ID
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }

    final announcement = Announcement(
      title: title,
      body: body,
      createdByUserId: UuidValue.fromString(authInfo.authId),
      createdAt: DateTime.now(),
      attachmentUrl: attachmentUrl,
    );

    return await Announcement.db.insertRow(session, announcement);
  }

  /// Lists announcements with read status for the current user.
  /// Returns announcements sorted by creation date (newest first).
  ///
  /// Parameters:
  /// - session: Current session (must be authenticated)
  /// - limit: Maximum number of announcements to return (default: 20)
  /// - offset: Number of announcements to skip for pagination (default: 0)
  ///
  /// Returns a list of maps containing announcement and isRead status.
  static Future<List<Map<String, dynamic>>> listAnnouncementsWithReadStatus(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    // Get authenticated user ID
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }
    final userId = UuidValue.fromString(authInfo.authId);

    // Get announcements sorted by creation date (newest first)
    final announcements = await Announcement.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    // For each announcement, check if current user has read it
    final result = <Map<String, dynamic>>[];
    for (final announcement in announcements) {
      final readRecord = await AnnouncementRead.db.findFirstRow(
        session,
        where: (t) =>
            (t.announcementId.equals(announcement.id!)) &
            (t.userId.equals(userId)),
      );

      result.add({
        'announcement': announcement,
        'isRead': readRecord != null,
      });
    }

    return result;
  }

  /// Gets a single announcement with read status for the current user.
  ///
  /// Parameters:
  /// - session: Current session (must be authenticated)
  /// - announcementId: ID of the announcement to retrieve
  ///
  /// Returns a map containing announcement and isRead status.
  /// Throws exception if announcement not found.
  static Future<Map<String, dynamic>> getAnnouncementWithReadStatus(
    Session session,
    int announcementId,
  ) async {
    // Get authenticated user ID
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }
    final userId = UuidValue.fromString(authInfo.authId);

    // Get announcement
    final announcement = await Announcement.db.findById(
      session,
      announcementId,
    );
    if (announcement == null) {
      throw Exception('Announcement not found');
    }

    // Check if user has read it
    final readRecord = await AnnouncementRead.db.findFirstRow(
      session,
      where: (t) =>
          (t.announcementId.equals(announcementId)) & (t.userId.equals(userId)),
    );

    return {
      'announcement': announcement,
      'isRead': readRecord != null,
    };
  }

  /// Marks an announcement as read for the current user.
  /// This operation is idempotent - calling it multiple times has no additional effect.
  ///
  /// Parameters:
  /// - session: Current session (must be authenticated)
  /// - announcementId: ID of the announcement to mark as read
  ///
  /// Returns true if successfully marked as read (or already read).
  static Future<bool> markAnnouncementAsRead(
    Session session,
    int announcementId,
  ) async {
    // Get authenticated user ID
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }
    final userId = UuidValue.fromString(authInfo.authId);

    // Check if announcement exists
    final announcement = await Announcement.db.findById(
      session,
      announcementId,
    );
    if (announcement == null) {
      throw Exception('Announcement not found');
    }

    // Check if already read
    final existingRead = await AnnouncementRead.db.findFirstRow(
      session,
      where: (t) =>
          (t.announcementId.equals(announcementId)) & (t.userId.equals(userId)),
    );

    // If already read, return true (idempotent)
    if (existingRead != null) {
      return true;
    }

    // Create read record
    final readRecord = AnnouncementRead(
      announcementId: announcementId,
      userId: userId,
      readAt: DateTime.now(),
    );

    await AnnouncementRead.db.insertRow(session, readRecord);
    return true;
  }

  /// Gets the count of unread announcements for the current user.
  /// Useful for displaying badge counts in the UI.
  ///
  /// Parameters:
  /// - session: Current session (must be authenticated)
  ///
  /// Returns the number of unread announcements.
  static Future<int> getUnreadCount(Session session) async {
    // Get authenticated user ID
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw Exception('User not authenticated');
    }
    final userId = UuidValue.fromString(authInfo.authId);

    // Get total announcement count
    final totalCount = await Announcement.db.count(session);

    // Get count of announcements this user has read
    final readCount = await AnnouncementRead.db.count(
      session,
      where: (t) => t.userId.equals(userId),
    );

    return totalCount - readCount;
  }

  /// Deletes an announcement (admin only, optional for MVP).
  /// Also deletes all associated read records.
  ///
  /// Parameters:
  /// - session: Current session (must be authenticated as admin)
  /// - announcementId: ID of the announcement to delete
  ///
  /// Returns true if successfully deleted.
  static Future<bool> deleteAnnouncement(
    Session session,
    int announcementId,
  ) async {
    // Check if announcement exists
    final announcement = await Announcement.db.findById(
      session,
      announcementId,
    );
    if (announcement == null) {
      throw Exception('Announcement not found');
    }

    // Delete all read records for this announcement
    await AnnouncementRead.db.deleteWhere(
      session,
      where: (t) => t.announcementId.equals(announcementId),
    );

    // Delete the announcement
    await Announcement.db.deleteRow(session, announcement);
    return true;
  }
}
