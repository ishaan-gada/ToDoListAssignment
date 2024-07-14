import 'package:campuscareerassignemnet/models/task_model.dart';
import 'package:equatable/equatable.dart';

abstract class ToDoListEvent extends Equatable {
  const ToDoListEvent();

  @override
  List<Object> get props => [];
}

class TaskAdded extends ToDoListEvent {
  final String text;

  const TaskAdded(this.text);

  @override
  List<Object> get props => [text];
}

class EditTask extends ToDoListEvent {
  final Task item;
  final String newText;

  const EditTask(this.item, this.newText);
}

class TaskSelected extends ToDoListEvent {
  final Task item;

  const TaskSelected(this.item);

  @override
  List<Object> get props => [item];
}

class TaskUnselected extends ToDoListEvent {
  final int index;

  const TaskUnselected(this.index);

  @override
  List<Object> get props => [index];
}

class TaskRemoved extends ToDoListEvent {
  final int index;

  const TaskRemoved(this.index);

  @override
  List<Object> get props => [index];
}

class LoadTask extends ToDoListEvent {
  const LoadTask();
}
