import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

Future<void> main(List<String> args) async {
  int n = args.isNotEmpty ? int.tryParse(args[0]) ?? 100 : 100;

  double A(int i, int j) {
    final div = ((i + j) * (i + j + 1) >> 1) + i + 1;
    return 1.0 / div;
  }

  final source = Float64List(n * n);
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n; j++) {
      source[i * n + j] = A(i, j);
    }
  }
  var matrix = Matrix.fromFlattenedList(source, n, n);
  print(SpectralNorm().approximate(matrix));
}

class SpectralNorm {
  num approximate(Matrix a) {
    var aTa = a.transpose() * a;
    var v = Vector.zero(a.rowCount);
    var u = Vector.filled(a.rowCount, 1);

    for (int i = 0; i < a.rowCount; i++) {
      v = (aTa * u).toVector();
      u = (aTa * v).toVector();
    }
    return sqrt(u.dot(v) / v.dot(v));
  }
}
