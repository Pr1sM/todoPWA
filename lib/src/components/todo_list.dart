import 'package:over_react/over_react.dart';

import 'package:todopwa/src/components/todo_container.dart';
import 'package:todopwa/src/models/todo.dart';

@Factory()
UiFactory<TodoListProps> TodoList;

@Props()
class TodoListProps extends UiProps {
  ContainerClickedCallback onContainerClick;
  List<Todo> todos;
}

@Component()
class TodoListComponent extends UiComponent<TodoListProps> {
  @override
  getDefaultMap() => (newProps()
    ..onContainerClick = null
    ..todos = []);

  @override
  shouldComponentUpdate(props, state) {
    TodoListProps tProps = typedPropsFactory(props);
    return tProps.todos != this.props.todos;
  }

  @override
  render() {
    List todoContainers = props.todos.map((todo) => (TodoContainer()
      ..onContainerClick = props.onContainerClick
      ..todo = todo
      ..key = todo.id)());

    return (Dom.div()..className = 'col')(
      Dom.h2()('Todo List'),
      (Dom.div()..className = 'list-group')(todoContainers),
    );
  }
}
