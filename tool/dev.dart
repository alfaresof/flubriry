// Local preview helper.
//
// The registry is generated source: it is deliberately ignored by git and
// never committed. This wrapper generates it for the current checkout and then
// launches Flutter, so contributors never have to call the generator by hand.
import 'dart:io';

Future<void> main(List<String> arguments) async {
  final generator = await Process.start(Platform.resolvedExecutable, [
    'run',
    'tool/generate_registry.dart',
  ], mode: ProcessStartMode.inheritStdio);
  final generatorExit = await generator.exitCode;
  if (generatorExit != 0) {
    exit(generatorExit);
  }

  final flutter = Platform.isWindows ? 'flutter.bat' : 'flutter';
  final flutterArgs = arguments.isEmpty
      ? ['run', '-d', 'chrome']
      : ['run', ...arguments];
  final runner = await Process.start(
    flutter,
    flutterArgs,
    mode: ProcessStartMode.inheritStdio,
  );
  exit(await runner.exitCode);
}
