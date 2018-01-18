import 'package:over_react/over_react.dart';

import 'package:todopwa/src/models/todo.dart';

typedef void NewTodoCallback(Todo todo);

@Factory()
UiFactory<AddTodoFormProps> AddTodoForm;

@Props()
class AddTodoFormProps extends UiProps {
  NewTodoCallback onNewTodo;
}

@State()
class AddTodoFormState extends UiState {
  String title;
  String description;
  bool readyToSubmit;
}

@Component()
class AddTodoFormComponent
    extends UiStatefulComponent<AddTodoFormProps, AddTodoFormState> {
  @override
  getDefaultProps() => (newProps()..onNewTodo = null);

  @override
  getInitialState() => (newState()
    ..title = ''
    ..description = ''
    ..readyToSubmit = false);

  @override
  render() => (Dom.div()..className = 'col')(
        Dom.h2()('Add New Todo'),
        (Dom.form()
          ..className = 'form-inline'
          ..onSubmit = _handleSubmit)(
          (Dom.input()
            ..className = 'form-control mb-2 mr-sm-2'
            ..type = 'text'
            ..id = '${props.key}todoAppTitleInput'
            ..value = this.state.title
            ..onChange = _handleTitleChange
            ..placeholder = 'Title')(),
          (Dom.textarea()
            ..className = 'form-control mb-2 mr-sm-2'
            ..id = '${props.key}todoAppDescInput'
            ..value = this.state.description
            ..onChange = _handleDescriptionChange
            ..placeholder = 'Description'
            ..rows = 1)(),
          (Dom.button()
            ..disabled = !state.readyToSubmit
            ..className = 'btn btn-primary mb-2'
            ..type = 'submit')('Submit'),
        ),
      );

  _handleSubmit(e) {
    e.preventDefault();
    Todo newTodo = new Todo(state.title, state.description, false);
    if (props.onNewTodo != null) {
      props.onNewTodo(newTodo);
    }
    setState(getInitialState());
  }

  _handleTitleChange(e) {
    setState(newState()
      ..title = e.target.value
      ..readyToSubmit =
          state.description.length > 0 && e.target.value.length > 0);
  }

  _handleDescriptionChange(e) {
    setState(newState()
      ..description = e.target.value
      ..readyToSubmit = state.title.length > 0 && e.target.value.length > 0);
  }
}
