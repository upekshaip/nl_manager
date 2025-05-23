import 'package:flutter/material.dart';

class MySectionItem extends StatelessWidget {
  final dynamic sectionContents;
  const MySectionItem({super.key, required this.sectionContents});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var sectionContent in sectionContents) ListTile(),
      ],
    );
  }
}
