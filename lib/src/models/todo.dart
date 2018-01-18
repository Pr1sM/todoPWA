import 'package:uuid/uuid.dart';

class Todo {
  Uuid _id;
  String _title;
  String _description;
  bool _isComplete;

  Todo(this._title, this._description, this._isComplete, [Uuid id]) {
    this._id = id ?? new Uuid();
  }

  Todo.copy(Todo original) {
    this._id = original.id;
    this._title = original.title;
    this._description = original.description;
    this._isComplete = original.isComplete;
  }

  Uuid get id => _id;
  String get title => _title;
  String get description => _description;
  bool get isComplete => _isComplete;

  @override
  int get hashCode => _id.hashCode;

  @override
  bool operator ==(Todo t) {
    return _id == t.id;
  }
}
