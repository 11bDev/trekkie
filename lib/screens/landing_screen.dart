import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27), // Deep space black-blue
              Color(0xFF1A1B4B), // Dark nebula purple
              Color(0xFF2D1B69), // Cosmic purple
              Color(0xFF1E3A5F), // Deep space blue
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon - Using actual app icon
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B46C1).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/trekkie_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Title
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFFFFFFF), // White
                          Color(0xFFB794F4), // Light purple
                          Color(0xFF9F7AEA), // Medium purple
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Trekkie',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tagline
                    const Text(
                      'The Ultimate Star Trek Timeline Tracker',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFE2E8F0), // Light gray-blue
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Features
                    _buildFeatureCard(
                      icon: Icons.live_tv,
                      title: '900+ Episodes',
                      description: 'Every Star Trek series from TOS to Strange New Worlds',
                      color: const Color(0xFF6B46C1), // Purple
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.movie,
                      title: '14 Movies',
                      description: 'All theatrical releases in chronological order',
                      color: const Color(0xFF4299E1), // Blue
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.timeline,
                      title: 'Timeline Order',
                      description: 'Watch in story chronological order or by release',
                      color: const Color(0xFF805AD5), // Violet
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.bookmark,
                      title: 'Track Progress',
                      description: 'Mark episodes watched and save favorites',
                      color: const Color(0xFF38B2AC), // Teal
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.sync,
                      title: 'Sync Everywhere',
                      description: 'Access your progress on web and Android',
                      color: const Color(0xFF9F7AEA), // Light purple
                    ),
                    const SizedBox(height: 48),

                    // CTA Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9F7AEA), // Light purple
                            Color(0xFF6B46C1), // Deep purple
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B46C1).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SignupScreen(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Secondary button - Already have account
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const LoginScreen(),
                        );
                      },
                      child: const Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Footer
                    Column(
                      children: [
                        const Text(
                          'Made with ❤️ for Trekkies',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'with Flutter by ',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // Open link in browser
                                final url = Uri.parse('https://11b.dev');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: const Text(
                                '11bDev',
                                style: TextStyle(
                                  color: Color(0xFF9F7AEA),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.6),
                  color.withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
