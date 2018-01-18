import 'package:over_react/over_react.dart';

@Factory()
UiFactory<TodoTitleProps> TodoTitle;

@Props()
class TodoTitleProps extends UiProps {
  int todoCount;
}

@Component()
class TodoTitleComponent extends UiComponent<TodoTitleProps> {
  @override
  getDefaultProps() => (newProps()..todoCount = 0);

  @override
  shouldComponentUpdate(props, state) {
    TodoTitleProps tProps = typedPropsFactory(props);
    return tProps.todoCount != this.props.todoCount;
  }

  @override
  render() => Dom.div()(
        Dom.h1()('Todos ${props.todoCount > 0 ? '(${props.todoCount})' : ''}'),
      );
}
