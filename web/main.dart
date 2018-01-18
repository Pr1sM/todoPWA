import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:todopwa/todopwa.dart';

void main() {
  setClientConfiguration();

  TodoAppStore store = new TodoAppStore();

  react_dom.render(Dom.div()(
      (TodoApp()..store = store)(),
  ), querySelector('#react_mount_point'));
}
