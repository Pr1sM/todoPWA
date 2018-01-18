import 'package:over_react/over_react.dart';

import 'package:todopwa/src/models/todo.dart';

typedef void ContainerClickedCallback(String todoId);
typedef void RemoveClickedCallback(String todoId);

@Factory()
UiFactory<TodoContainerProps> TodoContainer;

@Props()
class TodoContainerProps extends UiProps {
  ContainerClickedCallback onContainerClick;
  RemoveClickedCallback onRemoveClick;
  Todo todo;
}

@Component()
class TodoContainerComponent extends UiComponent<TodoContainerProps> {
  @override
  getDefaultProps() => (newProps()
    ..onContainerClick = null
    ..onRemoveClick = null
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
      ..add('list-group-item-success', props.todo.isComplete)
      ..add('flex-column');

    return (Dom.div()
      ..onClick = _handleContainerClick
      ..className = builder.toClassName())(
      (Dom.div()
        ..className =
            'd-flex w-100 justify-content-between align-items-center')(
        Dom.div()(
          Dom.h4()(props.todo.title),
          '${props.todo.description}',
        ),
        (Dom.div()..onClick = _handleRemoveClick)(
          (Dom.span()
            ..className = 'oi oi-x'
            ..title = 'x')(),
        ),
      ),
    );
  }

  _handleContainerClick(_) {
    if (props.onContainerClick != null) {
      props.onContainerClick(props.todo.id);
    }
  }

  _handleRemoveClick(_) {
    if (props.onRemoveClick != null) {
      props.onRemoveClick(props.todo.id);
    }
  }
}
