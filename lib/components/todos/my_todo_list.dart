import 'package:flutter/material.dart';
import 'package:nl_manager/components/my_loading.dart';
import 'package:nl_manager/tasks/course_task.dart';
import 'package:nl_manager/tasks/helpers.dart';
import 'package:nl_manager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class TodosList extends StatefulWidget {
  const TodosList({super.key});

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  Map<String, dynamic> todos = {};
  bool isLoading = false;
  String error = "";

  void doThis(SessionStateProvider session) async {
    setState(() {
      error = "";
      isLoading = true;
    });
    final course = Course(tokens: session.tokens.cast<String, String?>(), session: session.getMySession(), reverseDays: 15);
    var todos = await course.getTodos();
    if (todos.containsKey("error")) {
      setState(() {
        error = todos["error"];
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = false;
      error = "";
      session.setTodos(todos["todos"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionStateProvider>(
      builder: (context, mySession, child) => Container(
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
                    doThis(mySession);
                  },
                  color: Colors.white,
                ),
              ],
            ),
            if (isLoading)
              const Column(
                children: [MyLoading(), Padding(padding: EdgeInsets.only(top: 20))],
              ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (!isLoading && mySession.todos.isNotEmpty)
              Column(
                children: [
                  for (var todo in mySession.todos)
                    ListTile(
                      title: Text(todo["others"]["name"], style: const TextStyle(color: Colors.white)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Text(todo["course"]["coursecategory"], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 5),
                        Text(todo["course"]["fullname"], style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
