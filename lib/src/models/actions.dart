import 'package:uuid/uuid.dart';

import 'package:todopwa/src/models/todo.dart';

enum ActionType {
  doNothing,
  addTodo,
  editTodo,
  removeTodo,
  toggleTodo,
}

abstract class TodoAppAction {
  final ActionType type = ActionType.doNothing;
}

class AddTodoAction implements TodoAppAction {
  final ActionType type;
  Todo todo;

  AddTodoAction(this.todo) : this.type = ActionType.addTodo;
}

class EditTodoAction implements TodoAppAction {
  final ActionType type;
  Todo todo;

  EditTodoAction(this.todo) : this.type = ActionType.editTodo;
}

class RemoveTodoAction implements TodoAppAction {
  final ActionType type;
  Uuid todoId;

  RemoveTodoAction(this.todoId) : this.type = ActionType.removeTodo;
}

class ToggleTodoAction implements TodoAppAction {
  final ActionType type;
  Uuid todoId;

  ToggleTodoAction(this.todoId) : this.type = ActionType.toggleTodo;
}
