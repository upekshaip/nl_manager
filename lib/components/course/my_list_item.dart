import 'package:flutter/material.dart';
import 'package:nlmanager/components/course/my_section_items.dart';

class MyCourseListItem extends StatelessWidget {
  final dynamic sections;
  const MyCourseListItem({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var section in sections)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "• ${section["section_name"]}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  MySectionItem(sectionContents: section["section_content"]),
                  const SizedBox(height: 4),
                ],
              ),
            ),
        ],
      ),
    );
  }
}