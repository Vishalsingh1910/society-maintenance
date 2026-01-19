import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:societymaintenance_client/societymaintenance_client.dart';
import '../services/announcement_service.dart';
import '../services/profile_service.dart';
import 'announcement_detail_screen.dart';
import 'create_announcement_screen.dart';

/// Screen displaying list of all announcements with read/unread status
/// Accessible by all users (residents, admin, staff, guard)
/// Admins see a FAB to create new announcements
class AnnouncementsListScreen extends StatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  State<AnnouncementsListScreen> createState() => _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState extends State<AnnouncementsListScreen> {
  final _announcementService = AnnouncementService();
  final _profileService = ProfileService();
  
  List<Map<String, dynamic>> _announcements = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAdmin = false;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _checkAdminStatus();
    await _loadAnnouncements();
    await _loadUnreadCount();
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

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final announcements = await _announcementService.listAnnouncements(
        limit: 50,
        offset: 0,
      );
      setState(() {
        _announcements = announcements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load announcements: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _announcementService.getUnreadCount();
      setState(() {
        _unreadCount = count;
      });
    } catch (e) {
      // Ignore error, keep count at 0
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  void _navigateToDetail(Map<String, dynamic> announcementData) async {
    final announcement = announcementData['announcement'] as Announcement;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailScreen(
          announcementId: announcement.id!,
        ),
      ),
    );

    // Refresh list if announcement was read or deleted
    if (result == true) {
      await _loadData();
    }
  }

  void _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAnnouncementScreen(),
      ),
    );

    // Refresh list if announcement was created
    if (result == true) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.blue,
        actions: [
          if (_unreadCount > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_unreadCount unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create'),
              backgroundColor: Colors.blue,
            )
          : null,
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

    if (_announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.announcement_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No announcements yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            if (_isAdmin) ...[
              const SizedBox(height: 8),
              Text(
                'Tap the + button to create one',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcementData = _announcements[index];
          final announcement = announcementData['announcement'] as Announcement;
          final isRead = announcementData['isRead'] as bool;

          return _buildAnnouncementCard(announcement, isRead);
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement, bool isRead) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final formattedDate = dateFormat.format(announcement.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: isRead ? 1 : 3,
      child: InkWell(
        onTap: () => _navigateToDetail({
          'announcement': announcement,
          'isRead': isRead,
        }),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread indicator
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 20),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      announcement.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
