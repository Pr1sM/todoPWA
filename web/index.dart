import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' show setClientConfiguration;

void main() {
  setClientConfiguration();

  react_dom.render(Dom.div()(
    'This is a test!'
  ), querySelector('#react_mount_point'));
}
