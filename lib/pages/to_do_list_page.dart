import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionStateProvider, CourseStateProvider>(
      builder: (context, mySession, myCourse, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () async {
                  myCourse.refreshTodos(mySession);
                },
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: Colors.black,
          title: const Text('Todos'),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(children: [
              if (myCourse.isTodosLoading)
                const Column(
                  children: [
                    MyLoading(),
                    Padding(padding: EdgeInsets.only(top: 20))
                  ],
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
                        title: Text(todo["others"]["name"],
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(todo["deadline"],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              const SizedBox(height: 5),
                              Text(todo["course"]["fullname"],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                              Text(todo["course"]["coursecategory"],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                            ]),
                        trailing: MyHelper().getIcons(
                            "unknown", todo["others"]["icon"]["component"]),
                      ),
                  ],
                )
            ]),
          ),
        ),
      ),
    );
  }
}
