import 'package:societymaintenance_client/societymaintenance_client.dart';
import '../main.dart';

/// Service for managing announcements on the client side
/// Handles announcement fetching, creation, and read status tracking
class AnnouncementService {
  /// Lists announcements with read status for the current user
  /// Returns paginated list of announcements
  Future<List<Map<String, dynamic>>> listAnnouncements({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      return await client.announcement.listAnnouncements(
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw Exception('Failed to list announcements: $e');
    }
  }

  /// Gets details of a single announcement with read status
  Future<Map<String, dynamic>> getAnnouncementDetails(int announcementId) async {
    try {
      return await client.announcement.getAnnouncementDetails(announcementId);
    } catch (e) {
      throw Exception('Failed to get announcement details: $e');
    }
  }

  /// Marks an announcement as read for the current user
  /// This operation is idempotent - safe to call multiple times
  Future<bool> markAnnouncementRead(int announcementId) async {
    try {
      return await client.announcement.markAnnouncementRead(announcementId);
    } catch (e) {
      throw Exception('Failed to mark announcement as read: $e');
    }
  }

  /// Gets the count of unread announcements for the current user
  /// Useful for displaying badge counts in the UI
  Future<int> getUnreadCount() async {
    try {
      return await client.announcement.getUnreadCount();
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Creates a new announcement (admin only)
  Future<Announcement> createAnnouncement({
    required String title,
    required String body,
    String? attachmentUrl,
  }) async {
    try {
      return await client.announcement.createAnnouncement(
        title,
        body,
        attachmentUrl,
      );
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }

  /// Deletes an announcement (admin only)
  Future<bool> deleteAnnouncement(int announcementId) async {
    try {
      return await client.announcement.deleteAnnouncement(announcementId);
    } catch (e) {
      throw Exception('Failed to delete announcement: $e');
    }
  }
}
