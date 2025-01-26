import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySectionItem extends StatefulWidget {
  final dynamic sectionContents;
  const MySectionItem({super.key, required this.sectionContents});

  @override
  State<MySectionItem> createState() => _MySectionItemState();
}

class _MySectionItemState extends State<MySectionItem> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var sectionContent in widget.sectionContents)
          ListTile(
            trailing: SvgPicture.network(sectionContent["image"], width: 20, height: 20),
            title: Text(sectionContent["file_name"], style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }
}
