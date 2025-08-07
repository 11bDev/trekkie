import 'package:flutter/material.dart';
import '../services/captain_service.dart';

class CaptainAvatar extends StatelessWidget {
  final String? showId;
  final double size;
  final String? fallbackText;
  final Color? fallbackColor;

  const CaptainAvatar({
    super.key,
    this.showId,
    this.size = 40,
    this.fallbackText,
    this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    final captain = showId != null ? CaptainService.getCaptainForShow(showId!) : null;
    
    if (captain != null) {
      return _buildCaptainAvatar(captain);
    }
    
    return _buildFallbackAvatar(context);
  }

  Widget _buildCaptainAvatar(CaptainInfo captain) {
    // Get captain's last name
    final nameParts = captain.name.split(' ');
    final lastName = nameParts.last.toUpperCase();
    
    // Get era-appropriate colors
    final colors = _getEraColors(captain.name);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors['primary']!, colors['secondary']!],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors['accent']!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colors['primary']!.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                lastName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getNameFontSize(lastName),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          if (size > 50) ...[
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: colors['accent']!.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  captain.rank.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _getNameFontSize(String name) {
    // Adjust font size based on name length to fit better
    if (name.length <= 4) {
      return size * 0.28;
    } else if (name.length <= 6) {
      return size * 0.24;
    } else if (name.length <= 8) {
      return size * 0.20;
    } else {
      return size * 0.16;
    }
  }

  Map<String, Color> _getEraColors(String captainName) {
    switch (captainName) {
      case 'Jonathan Archer':
        return {
          'primary': const Color(0xFF1f4788), // Enterprise blue
          'secondary': const Color(0xFF2d5aa0),
          'accent': const Color(0xFF4169e1),
        };
      case 'Christopher Pike':
        return {
          'primary': const Color(0xFF1f4788), // TOS blue
          'secondary': const Color(0xFF2d5aa0),
          'accent': const Color(0xFFc9b037), // Command gold
        };
      case 'James T. Kirk':
        return {
          'primary': const Color(0xFFd4af37), // Command gold
          'secondary': const Color(0xFFb8860b),
          'accent': const Color(0xFF1f4788),
        };
      case 'Jean-Luc Picard':
        return {
          'primary': const Color(0xFF8b0000), // TNG command red
          'secondary': const Color(0xFFa52a2a),
          'accent': const Color(0xFFc9b037),
        };
      case 'Benjamin Sisko':
        return {
          'primary': const Color(0xFF8b0000), // DS9 command red
          'secondary': const Color(0xFF654321),
          'accent': const Color(0xFFdaa520),
        };
      case 'Kathryn Janeway':
        return {
          'primary': const Color(0xFF8b0000), // VOY command red
          'secondary': const Color(0xFF8b4513),
          'accent': const Color(0xFFc9b037),
        };
      case 'Michael Burnham':
        return {
          'primary': const Color(0xFF1f4788), // Discovery blue
          'secondary': const Color(0xFF4169e1),
          'accent': const Color(0xFFc9b037),
        };
      case 'Carol Freeman':
        return {
          'primary': const Color(0xFF8b0000), // Lower Decks command red
          'secondary': const Color(0xFFa52a2a),
          'accent': const Color(0xFF32cd32),
        };
      case 'Dal R\'El':
        return {
          'primary': const Color(0xFF4169e1), // Prodigy blue
          'secondary': const Color(0xFF6495ed),
          'accent': const Color(0xFFffd700),
        };
      default:
        return {
          'primary': const Color(0xFF1f4788),
          'secondary': const Color(0xFF2d5aa0),
          'accent': const Color(0xFFc9b037),
        };
    }
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fallbackColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          fallbackText ?? '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}