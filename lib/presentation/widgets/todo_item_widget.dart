import 'package:flutter/material.dart';
import 'package:todo_app/data/model/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todoModel;
  final int itemKey;
  final Function() onEditClick;
  final Function() onDeleteClick;

  const TodoItemWidget({
    super.key,
    required this.todoModel,
    required this.itemKey,
    required this.onEditClick,
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black54, width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: ListTile(
        title: Text(todoModel.title),
        subtitle: Text(todoModel.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEditClick(),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDeleteClick(),
            ),
          ],
        ),
      ),
    );
  }
}
