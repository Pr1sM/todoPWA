import 'package:todopwa/src/models/todo.dart';

class TodoAppState {
  List<Todo> todos;

  TodoAppState([List<Todo> todos]) {
    this.todos = todos ?? [];
  }

  TodoAppState.copy(TodoAppState original) {
    this.todos = [];
    original.todos.forEach((todo) => this.todos.add(new Todo.copy(todo)));
  }
}
