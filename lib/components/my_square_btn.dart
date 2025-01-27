import 'package:flutter/material.dart';

class MySquareBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const MySquareBtn({super.key, required this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 100, // Square button width
        height: 100, // Square button height
        decoration: BoxDecoration(
          color: Colors.blue.shade900, // Button background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 36, // Icon size
            ),
            const SizedBox(height: 8), // Space between icon and text
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
