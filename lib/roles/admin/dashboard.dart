import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/security_provider.dart';
import '../../utils/theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final security = Provider.of<SecurityProvider>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${auth.currentUser ?? 'Admin'}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role: ADMIN',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _metric('Users', '1,248', Icons.group, AppTheme.primaryColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _metric('Active', '142', Icons.devices, AppTheme.secondaryColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _metric('Alerts', '3', Icons.warning, AppTheme.accentColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: AppTheme.secondaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text('Security Status', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _statusMetric('Score', '${security.getSecurityScore()}/100', security.getSecurityScore() >= 80 ? AppTheme.successColor : AppTheme.warningColor)),
                      const SizedBox(width: 12),
                      Expanded(child: _statusMetric('Status', security.getSecurityStatus(), _statusColor(security.getSecurityStatus()))),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _navAction(context, 'Manage Users', Icons.admin_panel_settings, AppTheme.primaryColor, '/admin/manage-users'),
              _navAction(context, 'System Analytics', Icons.analytics, AppTheme.secondaryColor, '/admin/system-analytics'),
              _action(context, 'Content Library', Icons.folder, AppTheme.warningColor),
              _action(context, 'Security Scan', Icons.security, AppTheme.accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w600))]),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _statusMetric(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor)),
    ]);
  }

  Color _statusColor(String status) {
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

  Widget _action(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title coming soon'), behavior: SnackBarBehavior.floating)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, size: 32, color: color), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)],
          ),
        ),
      ),
    );
  }

  Widget _navAction(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, size: 32, color: color), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)],
          ),
        ),
      ),
    );
  }
}


