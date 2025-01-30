import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class TodosList extends StatelessWidget {
  const TodosList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionStateProvider, CourseStateProvider>(
      builder: (context, mySession, myCourse, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade900,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Todos",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () async {
                    myCourse.refreshTodos(mySession);
                  },
                  color: Colors.white,
                ),
              ],
            ),
            if (myCourse.isTodosLoading)
              const Column(
                children: [MyLoading(), Padding(padding: EdgeInsets.only(top: 20))],
              ),
            if (myCourse.todosError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  myCourse.todosError,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (!myCourse.isTodosLoading && myCourse.todos.isNotEmpty)
              Column(
                children: [
                  for (var todo in myCourse.todos)
                    ListTile(
                      title: Text(todo["others"]["name"], style: const TextStyle(color: Colors.white)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Text(todo["deadline"], style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 5),
                        Text(todo["course"]["fullname"], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        Text(todo["course"]["coursecategory"], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ]),
                      trailing: MyHelper().getIcons("unknown", todo["others"]["icon"]["component"]),
                    ),
                ],
              )
          ]),
        ),
      ),
    );
  }
}
