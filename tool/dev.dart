import 'package:dart_dev/dart_dev.dart';

main(args) async {
  config.analyze
    ..entryPoints = ['lib/', 'test/', 'tool/']
    ..strong = true;

  config.coverage.html = false;

  config.examples.port = 9000;

  config.format.paths = ['lib/', 'test/', 'tool/'];

  config.local
    ..taskPaths.add('bin')
    ..commandFilePattern = '([a-zA-Z0-9]+)_task.([a-zA-Z0-9]+)'
    ..executables['go'] = ['go', 'run'];

  config.test..unitTests = ['test/unit'];

  await dev(args);
}
