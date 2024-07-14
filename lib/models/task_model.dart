import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task extends Equatable {
  final int index;
  final String text;
  final bool isSelected;

  const Task(this.text, this.index, {this.isSelected = false});

  Task copyWith({String? text, bool? isSelected}) {
    return Task(text ?? this.text, index,
        isSelected: isSelected ?? this.isSelected);
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'text': text,
        'isSelected': isSelected,
      };

  // Convert a Map into a Task.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['text'] as String,
      json['index'] as int,
      isSelected: json['isSelected'] as bool,
    );
  }

  Future<void> saveTasksToSharedPreferences(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', encodedData);
  }

  Future<List<Task>> loadTasksFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List<dynamic> decodedData = jsonDecode(tasksString);
      return decodedData.map((json) => Task.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  List<Object> get props => [text, isSelected];
}
