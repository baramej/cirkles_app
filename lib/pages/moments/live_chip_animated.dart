import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LiveChipAnimated extends StatefulWidget {
  const LiveChipAnimated({super.key});

  @override
  State<LiveChipAnimated> createState() => _LiveChipAnimatedState();
}

class _LiveChipAnimatedState extends State<LiveChipAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration for one pulse cycle
    )..repeat(reverse: true); // Repeats the animation indefinitely, reversing each cycle
    // Define the animation: scales the dot from 80% to 120% of its size
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth acceleration and deceleration
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red[700], // YouTube's typical red
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live dot with pulsating animation
          ScaleTransition(
            scale: _animation, // Apply the scaling animation to the dot
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Live text
          Text(
            L10n.of(context).live,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
