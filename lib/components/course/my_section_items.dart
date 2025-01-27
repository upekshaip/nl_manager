import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            trailing: SvgPicture.network(sectionContent["image"], width: 20, height: 20),
            title: Text(sectionContent["file_name"], style: TextStyle(fontSize: 12, color: Colors.grey.shade300)),
            // tileColor: Colors.grey.shade900,
            shape: Border(
              bottom: BorderSide(
                color: Colors.grey.shade900,
                width: 1,
              ),
            ),
          ),
      ],
    );
  }
}
