import 'package:flutter/material.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo/Icon
            Icon(Icons.star, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),

            // Title
            Text(
              'Welcome to Trekkie!',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Your complete Star Trek viewing companion',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Features
            _buildFeature(
              context,
              Icons.list_alt,
              'Browse All Shows & Movies',
              'Explore every Star Trek series and film organized by timeline or series.',
            ),
            const SizedBox(height: 16),

            _buildFeature(
              context,
              Icons.theater_comedy,
              'Recommended Viewing Order',
              'Follow our curated chronological viewing order for the ultimate Star Trek experience.',
            ),
            const SizedBox(height: 16),

            _buildFeature(
              context,
              Icons.check_circle_outline,
              'Track Your Progress',
              'Mark episodes as watched and favorite your favorites. Your progress is saved locally.',
            ),
            const SizedBox(height: 16),

            _buildFeature(
              context,
              Icons.touch_app,
              'Quick Navigation',
              'Tap on any series in the Recommended tab to jump to that show in the By Series tab.',
            ),
            const SizedBox(height: 24),

            // Get Started Button
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Get Started', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
