import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campuscareerassignemnet/bloc/to_do_list_events.dart';
import 'package:campuscareerassignemnet/bloc/to_do_list_states.dart';
import 'package:campuscareerassignemnet/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ToDoListBloc extends Bloc<ToDoListEvent, ToDOListState> {
  final List<Task> _items;
  final pref = SharedPreferences.getInstance();
  ToDoListBloc(this._items)
      : super(ToDOListState(
          allTasks: _items,
          newTask: '',
          selectedTasks: const [],
        ));

  @override
  Stream<ToDOListState> mapEventToState(ToDoListEvent event) async* {
    if (event is TaskAdded) {
      final List<Task> newTaskList = List.from(state.allTasks);
      newTaskList.add(Task(event.text, newTaskList.length + 1));
      yield state.copyWith(
        allItems: newTaskList.toList(),
      );
    } else if (event is TaskSelected) {
      final List<Task> updatedOptions = List.from(state.allTasks);
      final Task updatedItem = updatedOptions[event.item.index - 1].copyWith(
        isSelected: !updatedOptions[event.item.index - 1].isSelected,
      );
      updatedOptions[event.item.index - 1] = updatedItem;
      final List<Task> selectedItems = List.from(state.selectedTasks);
      if (updatedItem.isSelected) {
        selectedItems.add(updatedItem);
      } else {
        selectedItems.removeWhere((item) => item.index == updatedItem.index);
      }

      // Yield the new state with updated lists
      yield state.copyWith(
        allItems: updatedOptions,
        selectedItems: selectedItems,
      );
    } else if (event is TaskUnselected) {
      final updatedOptions = _items
          .map((item) => item.index == event.index
              ? item.copyWith(isSelected: false)
              : item)
          .toList();
      final selectedItems = state.selectedTasks.toList();
      selectedItems.removeWhere((item) => item.index == event.index);
      yield state.copyWith(
        allItems: updatedOptions,
        selectedItems: selectedItems,
      );
    } else if (event is TaskRemoved) {
      final allTask = state.allTasks.toList();
      allTask.removeWhere((item) => item.index == event.index);
      yield state.copyWith(allItems: allTask.toList());
    } else if (event is EditTask) {
      final List<Task> updatedOptions = List.from(state.allTasks);
      final Task updatedItem =
          updatedOptions[event.item.index - 1].copyWith(text: event.newText);
      updatedOptions[event.item.index - 1] = updatedItem;
      final List<Task> selectedItems = List.from(state.selectedTasks);
      // Yield the new state with updated lists
      yield state.copyWith(
        allItems: updatedOptions,
        selectedItems: selectedItems,
      );
    } else if (event is LoadTask) {
      var request = http.Request(
          'GET', Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));

      http.StreamedResponse response = await request.send();

      var dat = await response.stream.bytesToString();
      var resp = jsonDecode(dat);
      if (response.statusCode == 200) {
        final List<Task> newTaskList = List.from(state.allTasks);
        newTaskList.add(Task(resp['title'], newTaskList.length + 1));
        yield state.copyWith(
          allItems: newTaskList.toList(),
        );
      }
    }
  }
}
