import 'package:flutter/material.dart';

class MyCourseList extends StatefulWidget {
  final List courses;

  const MyCourseList({super.key, required this.courses});

  @override
  State<MyCourseList> createState() => _MyCourseListState();
}

bool checkIsExpanded(dynamic item) {
  if (item.containsKey("isExpanded")) {
    return !item["isExpanded"];
  }
  return false;
}

class _MyCourseListState extends State<MyCourseList> {
  @override
  Widget build(BuildContext context) {
    var courses = widget.courses;
    return Expanded(
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          dividerColor: Colors.grey.shade600,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              courses[index]["isExpanded"] = !isExpanded;
            });
          },
          children: courses.map<ExpansionPanel>((dynamic course) {
            return ExpansionPanel(
                backgroundColor: Colors.black,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course["fullname"],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade300)),
                        Text(course["coursecategory"],
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade400)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: (course["progress"] as int) / 100,
                                backgroundColor: Colors.grey.shade700,
                                color: const Color.fromARGB(255, 0, 199, 10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${course["progress"]}%',
                                style: TextStyle(color: Colors.grey.shade400)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                body: MyCourseListItem(sections: course["contents"]),
                isExpanded: checkIsExpanded(course),
                canTapOnHeader: true);
          }).toList(),
        ),
      ),
    );
  }
}
