import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:version/version.dart';

const int defaultShelfPort = 8080;
const int defaultPubPort = 9100;
const String defaultHostname = '0.0.0.0';
const Iterable<Pattern> localHostAliases = const ['0.0.0.0'];

String pubServeHost;
Handler pubServeProxy;

Future<Null> main(List<String> arguments) async {
  var parser = new ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Print help menu.')
    ..addFlag('force-poll',
        defaultsTo: true,
        help: 'Run "pub serve" with the --force-poll option. Disable this '
            'option when path dependencies are not being used to reduce CPU '
            'usage.',
        negatable: true)
    ..addFlag('no-pub-serve',
        defaultsTo: false, help: 'Do not run pub serve, only run the proxy.')
    ..addOption('port',
        abbr: 'p',
        defaultsTo: defaultShelfPort.toString(),
        help: 'Port on which to serve the application.')
    ..addOption('hostname',
        abbr: 'n',
        defaultsTo: defaultHostname,
        help: 'Hostname on which to serve the application and the pub serve '
            'process.')
    ..addOption('pub-serve-port',
        defaultsTo: defaultPubPort.toString(),
        help: 'Port to use for the pub serve process.')
    ..addOption('web-compiler',
        allowed: ['dart2js', 'dartdevc', 'none'],
        defaultsTo: 'none',
        help: 'The Javascript compiler to use to serve the app.')
    ..addOption('entry-point',
        abbr: 'o',
        defaultsTo: 'web',
        help: 'The directory that should be served.');
  var parsedArgs = parser.parse(arguments);

  if (parsedArgs['help']) {
    print('Tooling for running this project locally.\n');
    print(parser.usage);
    return;
  }

  var hostname = parsedArgs['hostname'];
  var forcePoll = parsedArgs['force-poll'];
  var pubPort = _parsePort(parsedArgs['pub-serve-port'], defaultPubPort);
  var shelfPort = _parsePort(parsedArgs['port'], defaultShelfPort);
  var webCompiler = parsedArgs['web-compiler'];
  var entryPoint = parsedArgs['entry-point'];

  if (pubPort == shelfPort) {
    print(_color(
        new AnsiPen()..red(),
        'Cannot use the same port for both pub serve ($pubPort)'
        'and the application ($shelfPort).'));
    return;
  }

  pubServeHost = 'http://$hostname:$pubPort';
  pubServeProxy = proxyHandler(pubServeHost);

  if (parsedArgs['no-pub-serve']) {
    // Exit early, do not start pub serve.
    startShelf(hostname, shelfPort);
    return;
  }

  print('Starting pub serve...');

  List<String> args = [
    'serve',
    '--hostname=$hostname',
    '--port=$pubPort',
    forcePoll ? '--force-poll' : '--no-force-poll',
  ];

  // Check dart version before adding the web-compiler flag
  Version installedVersion = Version.parse(Platform.version.split(' ')[0]);
  Version oneTwentyFour = new Version(1, 24, 0);

  if (installedVersion >= oneTwentyFour) {
    args.add('--web-compiler=$webCompiler');
  }

  args.add(entryPoint);

  // Start pub serve
  Process pubServe = await Process.start('pub', args);
  Completer c = new Completer();
  StreamSubscription stdoutSubscription = pubServe.stdout
      .transform(UTF8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    print(line);
    if (line.startsWith('Build completed successfully') && !c.isCompleted) {
      c.complete();
    }
  });
  StreamSubscription stderrSubscription = pubServe.stderr
      .transform(UTF8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    if (!c.isCompleted) {
      c.completeError(new PubServeException(line));
      return;
    }
    print(line);
  });
  try {
    await c.future;

    startShelf(hostname, shelfPort);
  } on PubServeException catch (e) {
    await stdoutSubscription.cancel();
    await stderrSubscription.cancel();
    print(e);
  }
}

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

void startShelf(String hostname, int port) {
  print('Starting proxy...\n');
  print(_color(
      new AnsiPen()..green(), 'Serving app on:\t http://$hostname:$port\n'));
  shelf_io.serve(appHandler, hostname, port);
}

FutureOr<Response> appHandler(Request request) {
  String path = request.url.path;

  if (localHostAliases
      .any((alias) => request.requestedUri.host.startsWith(alias))) {
    return new Response.seeOther(
        request.requestedUri.replace(host: 'localhost'));
  }

  const allowedPaths = const [
    'packages/',
    'js/',
    'css/',
    'fonts/',
    'prod/',
    'img/',
    'sass/',
    'dart_sdk.js',
    'dart_stack_trace_mapper.js',
    'require.js',
    'web__main.js',
    'main.dart.js',
    'main.dart',
    'manifest.json',
    'service_worker.js',
    'favicon.ico',
    'browser_upgrade.html'
  ];

  if (!allowedPaths.any((allowed) => path.startsWith(allowed))) {
    Uri newPath;
    if(request.requestedUri.scheme == 'http') {
      newPath = request.requestedUri.replace(scheme: 'https', path: '/');
    } else {
      newPath = request.requestedUri.replace(path: '/');
    }

    request = _copyRequest(request, newPath);
  }
  return pubServeProxy(request);
}

Request _copyRequest(Request oldRequest, [Uri newPath]) {
  if (newPath == null) {
    newPath = oldRequest.url;
  }
  return new Request(oldRequest.method, newPath,
      protocolVersion: oldRequest.protocolVersion,
      headers: oldRequest.headers,
      body: oldRequest.read(),
      encoding: oldRequest.encoding,
      context: oldRequest.context);
}

class PubServeException implements Exception {
  String message;

  PubServeException(this.message);

  @override
  String toString() => 'Error starting pub serve: $message';
}

String _color(AnsiPen pen, String message) => pen(message);
