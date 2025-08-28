import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/security_provider.dart';
import 'utils/theme.dart';
import 'roles/admin/pages/manage_users_page.dart';
import 'roles/admin/pages/system_analytics_page.dart';
import 'roles/student/pages/modules_list_page.dart';
import 'roles/teacher/pages/create_assignment_page.dart';
import 'roles/teacher/pages/gradebook_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kmmhllczbjzqmwpuwpoo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttbWhsbGN6Ymp6cW13cHV3cG9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNzA1NjAsImV4cCI6MjA3MTk0NjU2MH0.q8F4UVIDYveulfGYAXHoeQ2JvGZ92M50tGLTohFFUcI',
  );
  runApp(const SecureLearnApp());
}

class SecureLearnApp extends StatelessWidget {
  const SecureLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SecurityProvider()),
      ],
      child: MaterialApp(
        title: 'SecureLearn - Mobile App Security',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/admin/manage-users': (context) => const ManageUsersPage(),
          '/admin/system-analytics': (context) => const SystemAnalyticsPage(),
          '/student/modules': (context) => const ModulesListPage(),
          '/teacher/create-assignment': (context) => const CreateAssignmentPage(),
          '/teacher/gradebook': (context) => const GradebookPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
