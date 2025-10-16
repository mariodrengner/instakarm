import 'dart:ui';
import 'package:flutter/material.dart';

/// A widget that creates a "glassmorphism" effect.
///
/// It features a blurred background, rounded corners, a subtle gradient,
/// and a border to create a frosted glass appearance.
class GlassCard extends StatelessWidget {
  /// The widget to display inside the card.
  final Widget child;

  /// The padding to apply to the child.
  final EdgeInsetsGeometry padding;

  /// An optional color to display as a small circle in the top-right corner.
  final Color? color;

  /// Creates a GlassCard.
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withAlpha(51), // 20% opacity
                Colors.white.withAlpha(26), // 10% opacity
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Colors.white.withAlpha(51), // 20% opacity
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              // Child content
              Padding(
                padding: padding,
                child: child,
              ),
              // Conditional color circle
              if (color != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
