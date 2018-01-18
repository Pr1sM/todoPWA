import 'dart:async';

import 'package:over_react/over_react.dart';

import 'package:todopwa/src/components/add_todo_form.dart';
import 'package:todopwa/src/components/title.dart';
import 'package:todopwa/src/components/todo_list.dart';
import 'package:todopwa/src/models/state.dart';
import 'package:todopwa/src/models/store.dart';

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
  getInitalState() => (newState()..appState = null);

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

    return Dom.div()((TodoTitle()..todoCount = state.appState.todos.length)(),
        AddTodoForm()(), (TodoList()..todos = state.appState.todos)());
  }
}
