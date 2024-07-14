import 'package:campuscareerassignemnet/Reusables/task_tile.dart';
import 'package:campuscareerassignemnet/bloc/to_do_list_bloc.dart';
import 'package:campuscareerassignemnet/bloc/to_do_list_events.dart';
import 'package:campuscareerassignemnet/bloc/to_do_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  late final ToDoListBloc _bloc;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController popupcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ToDoListBloc>();
    _bloc.add(const LoadTask());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 160, 203, 234),
      body: BlocBuilder<ToDoListBloc, ToDOListState>(
          builder: (context, state) => SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.1 * height,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 0.1 * height,
                          width: 0.8 * width,
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add Task',
                                hintStyle: TextStyle(color: Colors.black)),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (val) {},
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<ToDoListBloc>()
                                  .add(TaskAdded(_controller.text));
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                    SizedBox(
                      height: state.allTasks.length * 0.1 * height,
                      width: width,
                      child: ListView.builder(
                        itemCount: state.allTasks.length,
                        itemBuilder: (context, index) {
                          final item = state.allTasks[index];
                          return TaskTile(
                            text: item.text,
                            isSelected: item.isSelected,
                            onDismiss: () {
                              context
                                  .read<ToDoListBloc>()
                                  .add(TaskRemoved(item.index));
                            },
                            onChange: () {
                              context
                                  .read<ToDoListBloc>()
                                  .add(TaskSelected(item));
                            },
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 0.4 * height,
                                        width: 0.8 * width,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: popupcontroller,
                                              decoration: const InputDecoration(
                                                  hintText: "Enter new task",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black)),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<ToDoListBloc>()
                                                      .add(EditTask(
                                                          item,
                                                          popupcontroller
                                                              .text));
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
