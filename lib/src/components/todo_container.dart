import 'package:over_react/over_react.dart';

import 'package:todopwa/src/models/todo.dart';

typedef void ContainerClickedCallback(String todoId);
typedef void EditClickedCallback(Todo todo);
typedef void RemoveClickedCallback(String todoId);

@Factory()
UiFactory<TodoContainerProps> TodoContainer;

@Props()
class TodoContainerProps extends UiProps {
  ContainerClickedCallback onContainerClick;
  EditClickedCallback onEditClick;
  RemoveClickedCallback onRemoveClick;
  Todo todo;
}

@State()
class TodoContainerState extends UiState {
  bool editing;
  String editTitle;
  String editDescription;
}

@Component()
class TodoContainerComponent
    extends UiStatefulComponent<TodoContainerProps, TodoContainerState> {
  @override
  getDefaultProps() => (newProps()
    ..onContainerClick = null
    ..onEditClick = null
    ..onRemoveClick = null
    ..todo = null);

  @override
  getInitialState() => (newState()
    ..editing = false
    ..editTitle = props.todo.title
    ..editDescription = props.todo.description);

  @override
  shouldComponentUpdate(props, state) {
    TodoContainerProps tProps = typedPropsFactory(props);
    TodoContainerState tState = typedStateFactory(state);

    if (this.props.todo == null) {
      return tProps.todo != null;
    } else {
      return this.props.todo.id != tProps.todo.id ||
          this.props.todo.title != tProps.todo.title ||
          this.props.todo.description != tProps.todo.description ||
          this.props.todo.isComplete != tProps.todo.isComplete ||
          this.state.editing != tState.editing ||
          this.state.editTitle != tState.editTitle ||
          this.state.editDescription != tState.editDescription;
    }
  }

  @override
  render() {
    if (props.todo == null) {
      return null;
    } else if (state.editing) {
      return _renderEditState();
    } else {
      return _renderViewState();
    }
  }

  _renderViewState() {
    ClassNameBuilder builder = new ClassNameBuilder()
      ..add('list-group-item')
      ..add('list-group-item-success', props.todo.isComplete);

    return (Dom.div()
      ..onClick = _handleContainerClick
      ..className = builder.toClassName())(
      (Dom.div()..className = 'container')(
        (Dom.div()..className = 'row align-items-center')(
          (Dom.div()..className = 'col-10')(
            Dom.h4()(props.todo.title),
            '${props.todo.description}',
          ),
          (Dom.div()..className = 'col-2')(
            (Dom.div()..className = 'row align-items-center')(
              (Dom.div()
                ..className = 'col-6'
                ..onClick = _handleStartEditing)(
                (Dom.span()
                  ..className = 'oi oi-info'
                  ..title = 'info')(),
              ),
              (Dom.div()
                ..className = 'col-6'
                ..onClick = _handleRemoveClick)(
                (Dom.span()
                  ..className = 'oi oi-x'
                  ..title = 'x')(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _renderEditState() {
    return (Dom.div()..className = 'list-group-item')(
      (Dom.form()
        ..className = 'form-inline'
        ..onSubmit = _handleSubmit)(
        (Dom.label()
          ..className = 'mr-1'
          ..htmlFor = '${props.key}TodoEditTitle')('Title'),
        (Dom.input()
          ..className = 'form-control mr-2'
          ..id = '${props.key}TodoEditTitle'
          ..type = 'text'
          ..value = state.editTitle
          ..onChange = _handleTitleChange)(),
        (Dom.label()
          ..className = 'mr-1'
          ..htmlFor = '${props.key}TodoEditDesc')('Description'),
        (Dom.textarea()
          ..className = 'form-control mr-2'
          ..id = '${props.key}TodoEditDesc'
          ..value = state.editDescription
          ..onChange = _handleDescriptionChange
          ..rows = 1)(),
        (Dom.button()
          ..className = 'btn btn-primary mr-2'
          ..type = 'submit')(
          (Dom.span()
            ..className = 'oi oi-check'
            ..title = 'check')(),
        ),
        (Dom.button()
          ..className = 'btn'
          ..onClick = _handleCancel)(
          (Dom.span()
            ..className = 'oi oi-x'
            ..title = 'x')(),
        ),
      ),
    );
  }

  _handleCancel(e) {
    e.preventDefault();
    setState(getInitialState());
  }

  _handleContainerClick(_) {
    if (props.onContainerClick != null) {
      props.onContainerClick(props.todo.id);
    }
  }

  _handleDescriptionChange(e) {
    setState(newState()..editDescription = e.target.value);
  }

  _handleRemoveClick(e) {
    e.stopPropagation();
    if (props.onRemoveClick != null) {
      props.onRemoveClick(props.todo.id);
    }
  }

  _handleStartEditing(e) {
    e.stopPropagation();
    setState(newState()
      ..editTitle = props.todo.title
      ..editDescription = props.todo.description
      ..editing = true);
  }

  _handleSubmit(e) {
    e.preventDefault();
    Todo editTodo = new Todo(state.editTitle, state.editDescription,
        props.todo.isComplete, props.todo.id);
    if (props.onEditClick != null) {
      props.onEditClick(editTodo);
    }
    setState(newState()..editing = false);
  }

  _handleTitleChange(e) {
    setState(newState()..editTitle = e.target.value);
  }
}
