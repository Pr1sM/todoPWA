import 'package:redux/redux.dart';

import 'package:todopwa/src/models/actions.dart';
import 'package:todopwa/src/models/state.dart';
import 'package:todopwa/src/models/todo.dart';

TypedReducer<TodoAppState, TodoAppAction> TodoAppReducer =
    (TodoAppState state, TodoAppAction action) {
  TodoAppState newState = new TodoAppState.copy(state);
  switch (action.type) {
    case ActionType.addTodo:
      // Check if object can be added
      Todo todoToAdd = (action as AddTodoAction).todo;
      if (newState.todos.any((todo) => todo.id == todoToAdd.id)) {
        print(
            'Todo to Add cannot have the same id as an existing Todo! No change occuring!');
        break;
      }

      // Add new object to end of list
      newState.todos.add(todoToAdd);
      break;

    case ActionType.editTodo:
      // Ensure object was found in original data set
      Todo editTodo = (action as EditTodoAction).todo;
      Todo originalTodo = newState.todos
          .firstWhere((todo) => todo.id == editTodo.id, orElse: () => null);
      if (originalTodo == null) {
        print('Todo to Edit could not be found! No change occuring!');
        break;
      }

      // Swap objects
      int todoIndex = newState.todos.indexOf(originalTodo);
      newState.todos.removeAt(todoIndex);
      newState.todos.insert(todoIndex, editTodo);
      break;

    case ActionType.removeTodo:
      // Ensure object was found in original data set
      Todo todoToRemove = newState.todos.firstWhere(
          (todo) => todo.id == (action as RemoveTodoAction).todoId,
          orElse: () => null);
      if (todoToRemove == null) {
        print('Todo to Remove could not be found! No change occuring!');
        break;
      }

      newState.todos.remove(todoToRemove);
      break;

    case ActionType.toggleTodo:
      // Ensure object was found in original data set
      Todo todoToToggle = newState.todos.firstWhere(
          (todo) => todo.id == (action as ToggleTodoAction).todoId,
          orElse: () => null);
      if (todoToToggle == null) {
        print('Todo to Remove could not be found! No change occuring!');
        break;
      }

      Todo toggledTodo = new Todo(todoToToggle.title, todoToToggle.description,
          !todoToToggle.isComplete, todoToToggle.id);

      // Swap objects
      int todoIndex = newState.todos.indexOf(todoToToggle);
      newState.todos.removeAt(todoIndex);
      newState.todos.insert(todoIndex, toggledTodo);
      break;

    default:
      break;
  }

  return newState;
};
