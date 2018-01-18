import 'package:redux/redux.dart';

import 'package:todopwa/src/models/state.dart';
import 'package:todopwa/src/models/reducer.dart';

class TodoAppStore extends Store<TodoAppState> {
  static TodoAppStore _store = null;

  factory TodoAppStore() {
    if (_store != null) {
      return _store;
    }
    _store = new TodoAppStore._internal();

    return _store;
  }

  TodoAppStore._internal()
      : super(TodoAppReducer,
            initialState: new TodoAppState(), middleware: [_loggingMiddleware]);

  static _loggingMiddleware(store, action, NextDispatcher next) {
    print('${new DateTime.now()}: ${action.type}');

    next(action);
  }
}
