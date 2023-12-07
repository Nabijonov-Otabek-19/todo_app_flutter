import 'package:flutter/material.dart';
import 'package:todo_app/data/model/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todoModel;
  final int itemKey;
  final Function() onEditClick;
  final Function() onDeleteClick;
  final Function() onChangeClick;

  const TodoItemWidget({
    super.key,
    required this.todoModel,
    required this.itemKey,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.onChangeClick,
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
        title: Text(
          todoModel.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            decoration: todoModel.isDone ? TextDecoration.lineThrough : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(todoModel.time),
        leading: Checkbox(
          value: todoModel.isDone,
          onChanged: (bool? value) {
            onChangeClick();
          },
        ),
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
