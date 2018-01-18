import 'package:over_react/over_react.dart';

@Factory()
UiFactory<AddTodoFormProps> AddTodoForm;

@Props()
class AddTodoFormProps extends UiProps {}

@State()
class AddTodoFormState extends UiState {
  String title;
  String description;
}

@Component()
class AddTodoFormComponent
    extends UiStatefulComponent<AddTodoFormProps, AddTodoFormState> {
  @override
  getInitialState() => (newState()
    ..title = ''
    ..description = '');

  @override
  render() => (Dom.form()..onSubmit = _handleSubmit)(
        (Dom.div()..className = 'form-group')(
          Dom.label()('Title'),
          (Dom.input()
            ..className = 'form-control col-md-12'
            ..type = 'text'
            ..value = this.state.title
            ..onChange = _handleTitleChange)(),
        ),
        (Dom.div()..className = 'form-group')(
          Dom.label()('Description'),
          (Dom.textarea()
            ..className = 'form-control col-md-12'
            ..value = this.state.description
            ..onChange = _handleDescriptionChange)(),
        ),
        (Dom.button()..type = 'submit')('Submit'),
      );

  _handleSubmit(e) {
    e.preventDefault();
    print('Clicked Submit');
    setState(getInitialState());
  }

  _handleTitleChange(e) {
    print('Handling title change');
    setState(newState()..title = e.target.value);
  }

  _handleDescriptionChange(e) {
    print('Handling description change');
    setState(newState()..description = e.target.value);
  }
}
