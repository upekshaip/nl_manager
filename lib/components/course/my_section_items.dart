import 'package:flutter/material.dart';
import 'package:nl_manager/tasks/helpers.dart';

class MySectionItem extends StatelessWidget {
  final dynamic sectionContents;
  const MySectionItem({super.key, required this.sectionContents});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var sectionContent in sectionContents)
          ListTile(
            trailing: MyHelper().getIcons(sectionContent["ext"], sectionContent["url"]),
            title: Text(sectionContent["file_name"], style: TextStyle(fontSize: 12, color: Colors.grey.shade300)),
          ),
      ],
    );
  }
}
