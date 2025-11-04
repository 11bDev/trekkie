import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  bool _isEditingName = false;
  bool _isLoading = false;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStats();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }
  }

  Future<void> _loadStats() async {
    final stats = await _firestoreService.getUserStats();
    setState(() => _stats = stats);
  }

  Future<void> _updateDisplayName() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.updateProfile(displayName: _nameController.text.trim());
      setState(() => _isEditingName = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Name updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.signOut();
      if (mounted) {
        // Navigate back to root (which will be LandingScreen via AuthWrapper)
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('No user signed in'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User Avatar
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: user.photoURL != null
                        ? ClipOval(
                            child: Image.network(
                              user.photoURL!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.person,
                                      size: 50, color: Colors.white),
                            ),
                          )
                        : const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                // Display Name
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: _isEditingName
                        ? TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              border: InputBorder.none,
                            ),
                            autofocus: true,
                          )
                        : Text(user.displayName ?? 'No name set'),
                    subtitle: const Text('Display Name'),
                    trailing: _isEditingName
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _loadUserData();
                                  setState(() => _isEditingName = false);
                                },
                              ),
                              IconButton(
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Icon(Icons.check),
                                onPressed: _isLoading ? null : _updateDisplayName,
                              ),
                            ],
                          )
                        : IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => setState(() => _isEditingName = true),
                          ),
                  ),
                ),

                // Email
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(user.email ?? 'No email'),
                    subtitle: const Text('Email'),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),

                // Stats Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Your Stats',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.tv, color: Colors.blue),
                        title: Text(
                            '${_stats['watchedEpisodesCount'] ?? 0} Episodes Watched'),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Text(
                            '${_stats['favoriteEpisodesCount'] ?? 0} Favorite Episodes'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.movie, color: Colors.purple),
                        title: Text(
                            '${_stats['watchedMoviesCount'] ?? 0} Movies Watched'),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Text(
                            '${_stats['favoriteMoviesCount'] ?? 0} Favorite Movies'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sign out button
                OutlinedButton.icon(
                  onPressed: _signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
    );
  }
}
