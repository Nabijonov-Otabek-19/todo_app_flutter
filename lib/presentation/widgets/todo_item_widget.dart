import 'package:flutter/material.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(8),
            onPressed: (context) => onDeleteClick(),
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            icon: Icons.edit,
            backgroundColor: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8),
            onPressed: (context) => onEditClick(),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black54, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
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
          subtitle: Text(
            todoModel.time,
            style: TextStyle(
              color: todoModel.isDone ? Colors.black26 : Colors.black,
            ),
          ),
          leading: Checkbox(
            value: todoModel.isDone,
            onChanged: (bool? value) {
              onChangeClick();
            },
          ),
        ),
      ),
    );
  }
}
