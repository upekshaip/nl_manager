import 'package:flutter/material.dart';

class MySquareBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const MySquareBtn(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.label,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // add width to infinite to make it responsive
        width: 115,
        height: 100, // Square button height
        decoration: BoxDecoration(
          color: Colors.grey.shade900, // Button background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: const [
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
              color: color,
              size: 36, // Icon size
            ),
            const SizedBox(height: 8), // Space between icon and text
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
