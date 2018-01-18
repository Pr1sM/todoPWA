import 'package:redux/redux.dart';

import 'package:todopwa/src/models/actions.dart';
import 'package:todopwa/src/models/state.dart';
import 'package:todopwa/src/models/reducer.dart';

class TodoAppStore extends Store<TodoAppState> {
  static TodoAppStore _store = null;

  factory TodoAppStore() {
    if (_store != null) {
      return _store;
    }
    _store = new Store<TodoAppState>(TodoAppReducer,
        initialState: new TodoAppState(), middleware: [_loggingMiddleware]);

    return _store;
  }

  static _loggingMiddleware(
      TodoAppStore store, TodoAppAction action, NextDispatcher next) {
    print('${new DateTime.now()}: ${action.type}');

    next(action);
  }
}
