import 'package:over_react/over_react.dart';

import 'package:todopwa/src/models/todo.dart';

@Factory()
UiFactory<TodoContainerProps> TodoContainer;

@Props()
class TodoContainerProps extends UiProps {
  Todo todo;
}

@Component()
class TodoContainerComponent extends UiComponent<TodoContainerProps> {
  @override
  getDefaultProps() => (newProps()..todo = null);

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

    return (Dom.div()..className = 'list-group-item')(
      Dom.h4()(props.todo.title),
      Dom.div()(
          '${props.todo.isComplete ? 'COMPLETE' : 'INCOMPLETE'} - ${props.todo.description}'),
    );
  }
}
