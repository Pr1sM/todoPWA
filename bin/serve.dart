import 'dart:async';

import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

const int defaultPort = 8080;
const String defaultHostname = '0.0.0.0';
const Iterable<Pattern> localHostAliases = const ['0.0.0.0'];

var staticHandler;

Future<Null> main(List<String> arguments) async {
  var parser = new ArgParser()
      ..addFlag('help', abbr: 'h', help: 'Print help menu.')
      ..addOption('port', abbr: 'p', defaultsTo: defaultPort.toString(), help: 'Port on which to serve the application.')
      ..addOption('hostname', abbr: 'n', defaultsTo: defaultHostname, help: 'Host name on which to serve the application.')
      ..addOption('entry-point', abbr: 'o', defaultsTo: 'web', help: 'The directory that should be served.');
  var parsedArgs = parser.parse(arguments);

  if (parsedArgs['help']) {
    print(parser.usage);
    return;
  }

  var hostname = parsedArgs['hostname'];
  var port = _parsePort(parsedArgs['port'], defaultPort);
  var entryPoint = parsedArgs['entry-point'];

  staticHandler = shelf_static.createStaticHandler(entryPoint, defaultDocument: 'index.html');
  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests())
      .addHandler(appHandler);

  shelf_io.serve(handler, hostname, port).then((server) {
    print(_color(
        new AnsiPen()..green(), 'Serving app on:\t http://$hostname:$port\n'));
  });
}

FutureOr<shelf.Response> appHandler(shelf.Request request) {
  if (request.headers['x-forwarded-proto'] != 'https') {
    return new shelf.Response.seeOther(request.requestedUri.replace(scheme: 'https'));
  }

  return staticHandler(request);
}

String _color(AnsiPen pen, String message) => pen(message);

int _parsePort(String portString, int defaultPort) {
  int port = defaultPort;
  try {
    port = int.parse(portString);
  } catch (e) {
    print(_color(new AnsiPen()..red(),
        'Error parsing "$portString". Using default port: $defaultPort.'));
  }
  return port;
}
