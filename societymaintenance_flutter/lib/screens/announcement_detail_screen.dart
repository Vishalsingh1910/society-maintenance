import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:societymaintenance_client/societymaintenance_client.dart';
import '../services/announcement_service.dart';
import '../services/profile_service.dart';

/// Screen displaying full announcement details
/// Automatically marks announcement as read when opened
/// Admins can delete announcements from this screen
class AnnouncementDetailScreen extends StatefulWidget {
  final int announcementId;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcementId,
  });

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  final _announcementService = AnnouncementService();
  final _profileService = ProfileService();

  Announcement? _announcement;
  bool _isRead = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _checkAdminStatus();
    await _loadAnnouncement();
    await _markAsRead();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final profile = await _profileService.getMyProfile();
      setState(() {
        _isAdmin = profile.role == UserRole.admin;
      });
    } catch (e) {
      // Ignore error, default to non-admin
    }
  }

  Future<void> _loadAnnouncement() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _announcementService.getAnnouncementDetails(
        widget.announcementId,
      );
      setState(() {
        _announcement = data['announcement'] as Announcement;
        _isRead = data['isRead'] as bool;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load announcement: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead() async {
    try {
      await _announcementService.markAnnouncementRead(widget.announcementId);
      setState(() {
        _isRead = true;
      });
    } catch (e) {
      // Ignore error, marking as read is not critical
    }
  }

  Future<void> _deleteAnnouncement() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Are you sure you want to delete this announcement? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _announcementService.deleteAnnouncement(widget.announcementId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement deleted successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate deletion
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete announcement: $e')),
        );
      }
    }
  }

  Future<void> _openAttachment(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open attachment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement'),
        backgroundColor: Colors.blue,
        actions: [
          if (_isAdmin && _announcement != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteAnnouncement,
              tooltip: 'Delete announcement',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_announcement == null) {
      return const Center(child: Text('Announcement not found'));
    }

    final dateFormat = DateFormat('MMMM dd, yyyy • hh:mm a');
    final formattedDate = dateFormat.format(_announcement!.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _announcement!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Date
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Body
          Text(
            _announcement!.body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          // Attachment (if present)
          if (_announcement!.attachmentUrl != null) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.attach_file, color: Colors.grey[700]),
                const SizedBox(width: 8),
                const Text(
                  'Attachment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _openAttachment(_announcement!.attachmentUrl!),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _announcement!.attachmentUrl!,
                        style: TextStyle(
                          color: Colors.blue[700],
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.open_in_new, size: 20, color: Colors.blue[700]),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
