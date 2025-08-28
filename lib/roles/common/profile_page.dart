import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/supabase_service.dart';
import '../../utils/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final username = auth.currentUser;
      if (username == null) {
        setState(() {
          _error = 'Not authenticated';
          _loading = false;
        });
        return;
      }
      final data = await SupabaseService.getProfileByUsername(username: username);
      setState(() {
        _profile = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _profile == null
                  ? const Center(child: Text('No profile found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.person, color: AppTheme.primaryColor),
                            title: Text(_profile!['full_name'] ?? 'Unknown'),
                            subtitle: Text('Username: ${_profile!['username'] ?? '-'}'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.badge, color: AppTheme.secondaryColor),
                            title: const Text('Role'),
                            subtitle: Text((_profile!['role'] ?? '-').toString().toUpperCase()),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today, color: AppTheme.warningColor),
                            title: const Text('Member Since'),
                            subtitle: Text((_profile!['created_at'] ?? '').toString()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Security', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: _ChangePasswordForm(username: _profile!['username'] as String),
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  final String username;
  const _ChangePasswordForm({required this.username});

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final ok = await SupabaseService.verifyProfileCredentials(
        username: widget.username,
        password: _currentController.text,
      );
      if (!ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Current password is incorrect')));
        return;
      }
      await SupabaseService.updateProfilePassword(
        username: widget.username,
        newPassword: _newController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated')));
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextFormField(
            controller: _currentController,
            decoration: const InputDecoration(labelText: 'Current Password', prefixIcon: Icon(Icons.lock))
                .copyWith(),
            obscureText: true,
            validator: (v) => (v == null || v.isEmpty) ? 'Enter current password' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _newController,
            decoration: const InputDecoration(labelText: 'New Password', prefixIcon: Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmController,
            decoration: const InputDecoration(labelText: 'Confirm New Password', prefixIcon: Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (v) => v != _newController.text ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : const Text('Update Password'),
            ),
          ),
        ],
      ),
    );
  }
}



