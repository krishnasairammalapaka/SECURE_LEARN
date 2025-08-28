import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../roles/admin/dashboard.dart' as admin;
import '../roles/teacher/dashboard.dart' as teacher;
import '../roles/student/dashboard.dart' as student;
import '../providers/auth_provider.dart';
import '../providers/security_provider.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecureLearn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DashboardTab(),
          ModulesTab(),
          SecurityTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Security',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
    }
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, SecurityProvider>(
      builder: (context, authProvider, securityProvider, child) {
        final role = (authProvider.userRole ?? 'student').toLowerCase();
        // Route to role-specific dashboards
        if (role == 'admin') {
          return const admin.AdminDashboard();
        }
        if (role == 'teacher') {
          return const teacher.TeacherDashboard();
        }
        return const student.StudentDashboard();
      },
    );
  }

  // Legacy fallback (unused once role dashboards are in place)
  Widget _legacyDashboard(BuildContext context, String role, AuthProvider authProvider, SecurityProvider securityProvider) {
    return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${authProvider.currentUser ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Role: ${role.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Role-specific Highlights
              _buildRoleHighlights(context, role),
              const SizedBox(height: 16),

              // Security Status (common)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: AppTheme.secondaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Security Status',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSecurityMetric(
                              'Score',
                              '${securityProvider.getSecurityScore()}/100',
                              securityProvider.getSecurityScore() >= 80
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSecurityMetric(
                              'Status',
                              securityProvider.getSecurityStatus(),
                              _getStatusColor(securityProvider.getSecurityStatus()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Actions (role-aware)
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: _buildRoleActions(context, role),
              ),
              const SizedBox(height: 16),

              // Recent Activity (placeholder)
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final activities = [
                      {'title': 'Completed Module 1', 'time': '2 hours ago'},
                      {'title': 'Security Quiz Passed', 'time': '1 day ago'},
                      {'title': 'Profile Updated', 'time': '3 days ago'},
                    ];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(activities[index]['title']!),
                      subtitle: Text(activities[index]['time']!),
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildRoleHighlights(BuildContext context, String role) {
    List<Widget> items;
    switch (role) {
      case 'admin':
        items = [
          _highlightTile('Users', '1,248', Icons.group, AppTheme.primaryColor),
          _highlightTile('Active Sessions', '142', Icons.devices, AppTheme.secondaryColor),
          _highlightTile('Alerts', '3', Icons.warning, AppTheme.accentColor),
        ];
        break;
      case 'teacher':
        items = [
          _highlightTile('Courses', '6', Icons.menu_book, AppTheme.primaryColor),
          _highlightTile('Assignments', '12', Icons.assignment, AppTheme.secondaryColor),
          _highlightTile('To Grade', '27', Icons.grading, AppTheme.warningColor),
        ];
        break;
      default: // student
        items = [
          _highlightTile('Enrolled', '5', Icons.school, AppTheme.primaryColor),
          _highlightTile('Progress', '68%', Icons.trending_up, AppTheme.secondaryColor),
          _highlightTile('Pending', '2', Icons.pending_actions, AppTheme.warningColor),
        ];
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: items
              .map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: w)))
              .toList(),
        ),
      ),
    );
  }

  Widget _highlightTile(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRoleActions(BuildContext context, String role) {
    switch (role) {
      case 'admin':
        return [
          _buildQuickActionCard(context, 'Manage Users', Icons.admin_panel_settings, AppTheme.primaryColor, () => _showComingSoon(context)),
          _buildQuickActionCard(context, 'System Analytics', Icons.analytics, AppTheme.secondaryColor, () => _showComingSoon(context)),
          _buildQuickActionCard(context, 'Content Library', Icons.folder, AppTheme.warningColor, () => _navigateToModules(context)),
          _buildQuickActionCard(context, 'Security Scan', Icons.security, AppTheme.accentColor, () => _navigateToSecurity(context)),
        ];
      case 'teacher':
        return [
          _buildQuickActionCard(context, 'Create Assignment', Icons.assignment_add, AppTheme.primaryColor, () => _showComingSoon(context)),
          _buildQuickActionCard(context, 'Gradebook', Icons.grading, AppTheme.secondaryColor, () => _showComingSoon(context)),
          _buildQuickActionCard(context, 'Course Materials', Icons.menu_book, AppTheme.warningColor, () => _navigateToModules(context)),
          _buildQuickActionCard(context, 'Class Analytics', Icons.insights, AppTheme.accentColor, () => _showComingSoon(context)),
        ];
      default: // student
        return [
          _buildQuickActionCard(context, 'Start Learning', Icons.school, AppTheme.primaryColor, () => _navigateToModules(context)),
          _buildQuickActionCard(context, 'Practice Quiz', Icons.quiz, AppTheme.secondaryColor, () => _showComingSoon(context)),
          _buildQuickActionCard(context, 'View Progress', Icons.trending_up, AppTheme.warningColor, () => _showComingSoon(context)),
          _buildQuickActionCard(context, 'Security Scan', Icons.security, AppTheme.accentColor, () => _navigateToSecurity(context)),
        ];
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return AppTheme.successColor;
      case 'good':
        return AppTheme.secondaryColor;
      case 'fair':
        return AppTheme.warningColor;
      case 'poor':
      case 'critical':
        return AppTheme.accentColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  Widget _buildSecurityMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToModules(BuildContext context) {
    if (context.mounted) {
      final homeState = context.findAncestorStateOfType<_HomeScreenState>();
      homeState?.setState(() {
        homeState._selectedIndex = 1;
      });
    }
  }

  void _navigateToSecurity(BuildContext context) {
    if (context.mounted) {
      final homeState = context.findAncestorStateOfType<_HomeScreenState>();
      homeState?.setState(() {
        homeState._selectedIndex = 2;
      });
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class ModulesTab extends StatelessWidget {
  const ModulesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final role = (auth.userRole ?? 'student').toLowerCase();
        if (role == 'student') {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'SecureLearn Modules',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.flag, color: AppTheme.primaryColor),
                  title: const Text('SecureLearn - Basic Cybersecurity'),
                  subtitle: const Text('Foundations: threats, best practices, safe habits'),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.school, color: AppTheme.secondaryColor),
                  title: const Text('SecureLearn - Intermediate Cybersecurity'),
                  subtitle: const Text('OWASP basics, secure storage, network hygiene'),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.security, color: AppTheme.accentColor),
                  title: const Text('SecureLearn - Advanced Cybersecurity'),
                  subtitle: const Text('Threat modeling, advanced hardening, secure patterns'),
                ),
              ),
            ],
          );
        }
        return const Center(
          child: Text('Modules coming soon...'),
        );
      },
    );
  }
}

class SecurityTab extends StatelessWidget {
  const SecurityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Security features coming soon...'),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile coming soon...'),
    );
  }
}
