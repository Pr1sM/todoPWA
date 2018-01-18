import 'dart:async';

import 'package:over_react/over_react.dart';
import 'package:uuid/uuid.dart';

import 'package:todopwa/src/components/add_todo_form.dart';
import 'package:todopwa/src/components/title.dart';
import 'package:todopwa/src/components/todo_list.dart';
import 'package:todopwa/src/models/actions.dart';
import 'package:todopwa/src/models/state.dart';
import 'package:todopwa/src/models/store.dart';
import 'package:todopwa/src/models/todo.dart';

@Factory()
UiFactory<TodoAppProps> TodoApp;

@Props()
class TodoAppProps extends UiProps {
  TodoAppStore store;
}

@State()
class TodoAppComponentState extends UiState {
  TodoAppState appState;
}

@Component()
class TodoAppComponent
    extends UiStatefulComponent<TodoAppProps, TodoAppComponentState> {
  StreamSubscription _storeListener;

  @override
  getDefaultProps() => (newProps()..store = null);

  @override
  getInitialState() => (newState()..appState = null);

  @override
  componentWillMount() {
    super.componentWillMount();

    setState(newState()..appState = props.store.state);
  }

  @override
  componentDidMount() {
    super.componentDidMount();

    _storeListener = props.store.onChange
        .listen((state) => setState(newState()..appState = state));
  }

  @override
  componentWillUnmount() async {
    super.componentWillUnmount();

    await _storeListener.cancel();
  }

  @override
  render() {
    if (props.store == null) {
      return null;
    }

    return (Dom.div()..className = 'container')(
      (Dom.div()..className = 'row col-md-12')(
        (TodoTitle()..todoCount = state.appState.todos.length)(),
      ),
      (Dom.div()..className = 'row col-md-12')(
        (AddTodoForm()..onNewTodo = _handleNewTodo)(),
      ),
      (Dom.div()..className = 'row col-md-12')(
        (TodoList()
          ..onContainerClick = _handleToggleTodo
          ..onEditClick = _handleEditTodo
          ..onRemoveClick = _handleRemoveTodo
          ..todos = state.appState.todos)(),
      ),
    );
  }

  _handleNewTodo(Todo todo) {
    props.store.dispatch(new AddTodoAction(todo));
  }

  _handleEditTodo(Todo todo) {
    props.store.dispatch(new EditTodoAction(todo));
  }

  _handleToggleTodo(String todoId) {
    props.store.dispatch(new ToggleTodoAction(todoId));
  }

  _handleRemoveTodo(String todoId) {
    props.store.dispatch(new RemoveTodoAction(todoId));
  }
}
