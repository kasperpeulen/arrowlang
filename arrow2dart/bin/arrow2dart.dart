import 'package:args/args.dart';
import 'package:arrow2dart/arrow2dart.dart' show arrow2dart, dart2arrow;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

main(List<String> arguments) {
  final args = new ArgParser(allowTrailingOptions: true);

  args.addOption('input',
      help: 'The input file. If omitted stdin is used.',
      abbr: 'i'
  );
  args.addOption('output',
      help: 'The output file. If omitted stdout is used.',
      abbr: 'o'
  );
  args.addFlag('dart2arrow',
      help: 'Compile Dart to Arrow instead',
      abbr: 'd',
      negatable: false,
      defaultsTo: false
  );
  args.addFlag('help',
      help: 'Show help',
      abbr: 'h',
      negatable: false,
      defaultsTo: false
  );

  final options = args.parse(arguments);

  if (options['help']) {
    print('Usage: arrow2dart [--input <input-file>|--output <output-file>|--dart2arrow]\n');
    print('Example: arrow2dart -i myfile.arrow -o myfile.dart\n');
    print(args.usage);
    return;
  }

  final stdIo = new StdIo();

  final dart2arrow = options['dart2arrow'];

  final Input input = options['input'] == null
      ? stdIo
      : new FileIo(new File(options['input']));

  final Output output = options['output'] == null
      ? stdIo
      : new FileIo(new File(options['output']));

  parse(input, output, dart2arrow);
}

Future parse(Input input, Output output, bool useDart2arrow) {
  final conversion = useDart2arrow
    ? dart2arrow
    : arrow2dart;

  return input.read()
      .then(conversion)
      .then(output.write);
}

abstract class Input {
  Future<String> read();
}

abstract class Output {
  void write(String output);
}

class FileIo implements Input, Output {
  final File file;

  FileIo(this.file);

  Future<String> read() => file.readAsString();

  void write(String output) {
    final sink = file.openWrite();
    sink.write(output);
    sink.close();
  }
}

class StdIo implements Input, Output {
  Future<String> read() => stdin.map(UTF8.decode).join('\n');

  void write(String output) => stdout.write(output);
}
