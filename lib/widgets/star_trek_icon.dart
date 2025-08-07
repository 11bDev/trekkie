import 'package:flutter/material.dart';

class StarTrekIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const StarTrekIcon({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).primaryColor;
    
    return CustomPaint(
      size: Size(size, size),
      painter: StarTrekDeltaPainter(iconColor),
    );
  }
}

class StarTrekDeltaPainter extends CustomPainter {
  final Color color;

  StarTrekDeltaPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Create the Star Trek delta shield path
    final path = Path();
    
    // Top point
    path.moveTo(size.width * 0.5, size.height * 0.1);
    
    // Right side
    path.lineTo(size.width * 0.85, size.height * 0.9);
    
    // Bottom curve (right to center)
    path.quadraticBezierTo(
      size.width * 0.65, size.height * 0.8,
      size.width * 0.5, size.height * 0.75,
    );
    
    // Bottom curve (center to left)
    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.8,
      size.width * 0.15, size.height * 0.9,
    );
    
    // Left side back to top
    path.lineTo(size.width * 0.5, size.height * 0.1);
    
    path.close();

    // Fill the delta
    canvas.drawPath(path, paint);
    
    // Add stroke
    canvas.drawPath(path, strokePaint);

    // Add inner curve detail
    final innerPath = Path();
    innerPath.moveTo(size.width * 0.5, size.height * 0.4);
    innerPath.quadraticBezierTo(
      size.width * 0.6, size.height * 0.6,
      size.width * 0.5, size.height * 0.75,
    );
    innerPath.quadraticBezierTo(
      size.width * 0.4, size.height * 0.6,
      size.width * 0.5, size.height * 0.4,
    );

    final innerPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}