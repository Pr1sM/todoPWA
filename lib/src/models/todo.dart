import 'package:uuid/uuid.dart';

class Todo {
  static final Uuid _uuid = new Uuid();

  var _id;
  String _title;
  String _description;
  bool _isComplete;

  Todo(this._title, this._description, this._isComplete, [var id]) {
    this._id = id ?? _uuid.v4();
  }

  Todo.copy(Todo original) {
    this._id = original.id;
    this._title = original.title;
    this._description = original.description;
    this._isComplete = original.isComplete;
  }

  dynamic get id => _id;
  String get title => _title;
  String get description => _description;
  bool get isComplete => _isComplete;

  @override
  int get hashCode => _id;

  @override
  bool operator ==(dynamic t) {
    if (t is Todo) {
      return _id == t.id;
    }
    return false;
  }
}
