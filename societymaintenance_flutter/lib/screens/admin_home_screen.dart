import 'package:flutter/material.dart';

/// Admin home screen with full system access
/// Provides access to user management, announcements, complaints, and all system features
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have full system access',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.people,
                    title: 'User Management',
                    subtitle: 'Manage users & roles',
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Navigate to user management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User Management - Coming Soon')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.announcement,
                    title: 'Announcements',
                    subtitle: 'Create & manage',
                    color: Colors.orange,
                    onTap: () {
                      // TODO: Navigate to announcements
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Announcements - Coming Soon')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.report_problem,
                    title: 'Complaints',
                    subtitle: 'View & assign',
                    color: Colors.red,
                    onTap: () {
                      // TODO: Navigate to complaints
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Complaints - Coming Soon')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'System config',
                    color: Colors.grey,
                    onTap: () {
                      // TODO: Navigate to settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings - Coming Soon')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
