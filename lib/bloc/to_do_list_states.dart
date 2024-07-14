import 'package:campuscareerassignemnet/models/task_model.dart';
import 'package:equatable/equatable.dart';

class ToDOListState extends Equatable {
  final List<Task> allTasks;
  final String newTask;
  final List<Task> selectedTasks;

  const ToDOListState({
    required this.allTasks,
    required this.newTask,
    required this.selectedTasks,
  });

  ToDOListState copyWith({
    List<Task>? allItems,
    String? searchText,
    List<Task>? selectedItems,
  }) {
    return ToDOListState(
      allTasks: allItems ?? allTasks,
      newTask: searchText ?? newTask,
      selectedTasks: selectedItems ?? selectedTasks,
    );
  }

  @override
  List<Object> get props => [allTasks, newTask, selectedTasks];
}
