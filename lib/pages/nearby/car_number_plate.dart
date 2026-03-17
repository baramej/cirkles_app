import 'package:flutter/material.dart';

class CarNumberPlate extends StatelessWidget {
  /// The number plate string to display.
  final String number;

  const CarNumberPlate({
    super.key,
    required this.number,
  });

  static const plateBackgroundColor = Color(0xFFFDD835);
  static const plateBorderColor = Color(0xFF424242);

  @override
  Widget build(BuildContext context) {
    // Dimensions for the number plate.
    // These values can be adjusted for different sizes.
    const plateHeight = 48.0;
    const borderRadius = 8.0;
    const borderWidth = 1.0;

    // Dimensions for the small corner dots.
    const dotSize = 4.0;
    // Distance from the plate's outer edge to the center of the dot.
    const dotOffsetFromEdge = 10.0;

    return Container(
      height: plateHeight,
      // The BoxDecoration defines the plate's visual properties:
      // background color, border, rounded corners, and shadow.
      decoration: BoxDecoration(
        color: plateBackgroundColor,
        border: Border.all(color: plateBorderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45, // Dark shadow
            offset: Offset(0, 4), // Shadow slightly below
            blurRadius: 8.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center, // Centers the main text
        children: [
          // The number plate text displayed in the center.
          Text(number),
          // --- Four corner dots ---
          // Positioned widgets are used to place the dots precisely.
          // The dotOffsetFromEdge - (dotSize / 2) calculation ensures the
          // center of the dot is at 'dotOffsetFromEdge' distance from the edge.

          // Top-left dot
          Positioned(
            top: dotOffsetFromEdge - (dotSize / 2),
            left: dotOffsetFromEdge - (dotSize / 2),
            child: _buildDot(dotSize, plateBorderColor),
          ),
          // Top-right dot
          Positioned(
            top: dotOffsetFromEdge - (dotSize / 2),
            right: dotOffsetFromEdge - (dotSize / 2),
            child: _buildDot(dotSize, plateBorderColor),
          ),
          // Bottom-left dot
          Positioned(
            bottom: dotOffsetFromEdge - (dotSize / 2),
            left: dotOffsetFromEdge - (dotSize / 2),
            child: _buildDot(dotSize, plateBorderColor),
          ),
          // Bottom-right dot
          Positioned(
            bottom: dotOffsetFromEdge - (dotSize / 2),
            right: dotOffsetFromEdge - (dotSize / 2),
            child: _buildDot(dotSize, plateBorderColor),
          ),
        ],
      ),
    );
  }

  // Helper method to create a single circular dot.
  Widget _buildDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
