import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

Future<void> main(List<String> args) async {
  int n = args.isNotEmpty ? int.tryParse(args[0]) ?? 100 : 100;

  print(SpectralNorm().approximate(n));
}

class SpectralNorm {
  final List<Float64List> columns = [];
  final List<Float64List> rows = [];

  double approximate(int n) {
    final u = Float64List(n);
    for (int i = 0; i < n; i++) {
      u[i] = 1;
    }

    final v = Float64List(n);
    for (int i = 0; i < n; i++) {
      v[i] = 0;
    }

    /* return element i,j of infinite matrix A */
    double A(int i, int j) {
      final div = ((i + j) * (i + j + 1) >> 1) + i + 1;
      return 1.0 / div;
    }

    for (var i = 0; i < n; i++) {
      final col = Float64List(n);
      for (int j = 0; j < n; j++) {
        col[j] = A(i, j);
      }
      columns.add(col);
    }
    for (var i = 0; i < n; i++) {
      final row = Float64List(n);
      for (int j = 0; j < n; j++) {
        row[j] = A(j, i);
      }
      rows.add(row);
    }

    var w = Float64List(n);
    for (int i = 0; i < 10; i++) {
      multiplyAtAv(w, u, v);
      multiplyAtAv(w, v, u);
    }

    double vBv = 0, vv = 0;
    for (int i = 0; i < n; i++) {
      vBv += u[i] * v[i];
      vv += v[i] * v[i];
    }

    return sqrt(vBv / vv);
  }

  /* multiply vector v by matrix A */
  void multiplyAv(int n, Float64List v, Float64List ret) {
    for (int i = 0; i < n; i++) {
      ret[i] = 0;
      for (int j = 0; j < n; j++) {
        ret[i] += columns[i][j] * v[j];
      }
    }
  }

  /* multiply vector v by matrix A transposed */
  void multiplyAtv(int n, Float64List v, Float64List ret) {
    for (int i = 0; i < n; i++) {
      ret[i] = 0;
      for (int j = 0; j < n; j++) {
        ret[i] += rows[i][j] * v[j];
      }
    }
  }

  /* multiply vector v by matrix A and then by matrix A transposed */
  void multiplyAtAv(Float64List w, Float64List v, Float64List ret) {
    multiplyAv(w.length, v, w);
    multiplyAtv(w.length, w, ret);
  }
}
