import 'package:flutter/material.dart';
import 'package:societymaintenance_client/societymaintenance_client.dart';
import '../services/profile_service.dart';
import 'admin_home_screen.dart';
import 'resident_home_screen.dart';
import 'guard_home_screen.dart';
import 'staff_home_screen.dart';

/// Widget that handles role-based navigation after authentication
/// Fetches user profile and routes to appropriate home screen based on role
class RoleBasedHome extends StatefulWidget {
  final VoidCallback onSignOut;

  const RoleBasedHome({super.key, required this.onSignOut});

  @override
  State<RoleBasedHome> createState() => _RoleBasedHomeState();
}

class _RoleBasedHomeState extends State<RoleBasedHome> {
  final _profileService = ProfileService();
  UserProfile? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _profileService.getMyProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
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
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onSignOut,
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      );
    }

    // Route based on user role
    final role = _profile?.role;
    
    Widget homeScreen;
    switch (role) {
      case UserRole.admin:
        homeScreen = AdminHomeScreen();
        break;
      case UserRole.guard:
        homeScreen = GuardHomeScreen();
        break;
      case UserRole.staff:
        homeScreen = StaffHomeScreen();
        break;
      case UserRole.resident:
      default:
        homeScreen = ResidentHomeScreen();
        break;
    }

    // Wrap with drawer for sign out option
    return Scaffold(
      body: homeScreen,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: _getColorForRole(role),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _profile?.fullName.isEmpty ?? true 
                        ? 'User' 
                        : _profile!.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getRoleDisplayName(role),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile - Coming Soon')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                widget.onSignOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForRole(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return Colors.deepPurple;
      case UserRole.guard:
        return Colors.indigo;
      case UserRole.staff:
        return Colors.teal;
      case UserRole.resident:
      default:
        return Colors.green;
    }
  }

  String _getRoleDisplayName(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.guard:
        return 'Security Guard';
      case UserRole.staff:
        return 'Maintenance Staff';
      case UserRole.resident:
      default:
        return 'Resident';
    }
  }
}
