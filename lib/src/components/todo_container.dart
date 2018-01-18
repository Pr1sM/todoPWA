import 'package:over_react/over_react.dart';

import 'package:todopwa/src/models/todo.dart';

typedef void ContainerClickedCallback(String todoId);

@Factory()
UiFactory<TodoContainerProps> TodoContainer;

@Props()
class TodoContainerProps extends UiProps {
  ContainerClickedCallback onContainerClick;
  Todo todo;
}

@Component()
class TodoContainerComponent extends UiComponent<TodoContainerProps> {
  @override
  getDefaultProps() => (newProps()
    ..onContainerClick = null
    ..todo = null);

  @override
  shouldComponentUpdate(props, state) {
    TodoContainerProps tProps = typedPropsFactory(props);
    if (this.props.todo == null) {
      return tProps.todo != null;
    } else {
      return this.props.todo.id != tProps.todo.id ||
          this.props.todo.title != tProps.todo.title ||
          this.props.todo.description != tProps.todo.description ||
          this.props.todo.isComplete != tProps.todo.isComplete;
    }
  }

  @override
  render() {
    if (props.todo == null) {
      return null;
    }

    ClassNameBuilder builder = new ClassNameBuilder()
      ..add('list-group-item')
      ..add('list-group-item-success', props.todo.isComplete);

    return (Dom.div()
      ..onClick = _handleContainerClick
      ..className = builder.toClassName())(
      Dom.h4()(props.todo.title),
      Dom.div()('${props.todo.description}'),
    );
  }

  _handleContainerClick(_) {
    if (props.onContainerClick != null) {
      props.onContainerClick(props.todo.id);
    }
  }
}
