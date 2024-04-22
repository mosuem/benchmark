import 'dart:io';

void main() {
  var n = 5000;
  for (var element in ['benchmark2_simd', 'benchmark3', 'benchmark2']) {
    Process.runSync(
      'dart',
      ['compile', 'exe', 'bin/$element.dart'],
      workingDirectory: '/home/mosum/projects/fun/benchmark/',
    );
    var runSync = Process.runSync(
      'time',
      ['./bin/$element.exe', n.toString()],
      workingDirectory: '/home/mosum/projects/fun/benchmark/',
    );
    print('$element: ${runSync.stderr}');
  }
}
