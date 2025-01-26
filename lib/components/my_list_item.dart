import 'package:flutter/material.dart';
import 'package:nl_manager/components/my_section_items.dart';

class MyCourseListItem extends StatefulWidget {
  final dynamic sections;
  const MyCourseListItem({super.key, required this.sections});

  @override
  State<MyCourseListItem> createState() => _MyCourseListItemState();
}

class _MyCourseListItemState extends State<MyCourseListItem> {
  @override
  Widget build(BuildContext context) {
    final sections = widget.sections;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var section in sections)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                Text(
                  "• ${section["section_name"]}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MySectionItem(sectionContents: section["section_content"]),
                const SizedBox(height: 4),
              ],
            ),
        ],
      ),
    );
  }
}
