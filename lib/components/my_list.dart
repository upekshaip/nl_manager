import 'package:flutter/material.dart';
import 'package:nl_manager/components/my_list_item.dart';

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
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              courses[index]["isExpanded"] = !isExpanded;
            });
          },
          children: courses.map<ExpansionPanel>((dynamic course) {
            return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course["fullname"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(course["coursecategory"],
                            style: const TextStyle(
                              fontSize: 12,
                            )),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: (course["progress"] as int) / 100,
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.blue.shade500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${course["progress"]}%'),
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
