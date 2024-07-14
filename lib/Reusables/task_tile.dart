import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function? onDismiss, onPressed, onChange;

  const TaskTile(
      {super.key,
      required this.text,
      this.isSelected = false,
      this.onDismiss,
      this.onPressed,
      this.onChange});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {DismissDirection.endToStart: 0.2},
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            if (onDismiss != null) {
              onDismiss!();
            }
            HapticFeedback.lightImpact();
          }
          if (direction == DismissDirection.startToEnd) {
            if (onPressed != null) {
              onPressed!();
            }
            HapticFeedback.lightImpact();
          }
        },
        child: Container(
            color: const Color.fromARGB(255, 160, 203, 234),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.black,
                        decoration: isSelected
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed!();
                      }
                    },
                    icon: const Icon(Icons.edit)),
                Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      if (onChange != null) {
                        onChange!();
                      }
                    })
              ],
            )));
  }
}
