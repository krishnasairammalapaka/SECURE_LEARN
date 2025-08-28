import 'package:flutter/material.dart';
import '../../../utils/theme.dart';

class ModulesListPage extends StatelessWidget {
  const ModulesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SecureLearn Modules')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ModuleCard(
            icon: Icons.flag,
            color: AppTheme.primaryColor,
            title: 'SecureLearn - Basic Cybersecurity',
            subtitle: 'Foundations: threats, best practices, safe habits',
          ),
          SizedBox(height: 8),
          _ModuleCard(
            icon: Icons.school,
            color: AppTheme.secondaryColor,
            title: 'SecureLearn - Intermediate Cybersecurity',
            subtitle: 'OWASP basics, secure storage, network hygiene',
          ),
          SizedBox(height: 8),
          _ModuleCard(
            icon: Icons.security,
            color: AppTheme.accentColor,
            title: 'SecureLearn - Advanced Cybersecurity',
            subtitle: 'Threat modeling, advanced hardening, secure patterns',
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _ModuleCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}


