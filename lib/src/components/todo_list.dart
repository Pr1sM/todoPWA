import 'package:over_react/over_react.dart';

import 'package:todopwa/src/components/todo_container.dart';
import 'package:todopwa/src/models/todo.dart';

@Factory()
UiFactory<TodoListProps> TodoList;

@Props()
class TodoListProps extends UiProps {
  List<Todo> todos;
}

@Component()
class TodoListComponent extends UiComponent<TodoListProps> {
  @override
  getDefaultMap() => (newProps()..todos = []);

  @override
  shouldComponentUpdate(props, state) {
    TodoListProps tProps = typedPropsFactory(props);
    return tProps.todos != this.props.todos;
  }

  @override
  render() {
    List todoContainers = props.todos.map((todo) {
      return (TodoContainer()
        ..todo = todo
        ..key = todo.id)();
    });

    return (Dom.div()..className = 'list-group')(todoContainers);
  }
}
