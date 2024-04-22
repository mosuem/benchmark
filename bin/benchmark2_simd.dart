// The Computer Language Benchmarks Game
// https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
//
// contributed by Jos Hirth
// based on the JavaScript version by Ian Osgood with modifications by Isaac Gouy

import 'dart:math' as math;
import 'dart:typed_data';

double A(int i, int j) {
  return ((j + i) * (i + j + 1) >> 1) + i + 1;
}

void main(List<String> args) {
  final n = args.isNotEmpty ? int.parse(args[0]) : 100;
  print(SpectralNorm(n).spectralNorm().toStringAsFixed(9));
}

class SpectralNorm {
  int n;
  SpectralNorm(int n) : n = n ~/ 2;

  void Au(Float64x2List u, Float64x2List w) {
    for (var i = 0; i < n; ++i) {
      final i2 = i * 2;
      var t = Float64x2.zero();
      var t2 = Float64x2.zero();
      for (var j = 0; j < n; ++j) {
        final j2 = j * 2;
        t += u[j] / Float64x2(A(i2, j2), A(i2, j2 + 1));
        t2 += u[j] / Float64x2(A(i2 + 1, j2), A(i2 + 1, j2 + 1));
      }
      w[i] = Float64x2(t.x + t.y, t2.x + t2.y);
    }
  }

  void atu(Float64x2List w, Float64x2List v) {
    for (var i = 0; i < n; ++i) {
      final i2 = i * 2;
      var t = Float64x2.zero();
      var t2 = Float64x2.zero();
      for (var j = 0; j < n; ++j) {
        final j2 = j * 2;
        t += w[j] / Float64x2(A(j2, i2), A(j2 + 1, i2));
        t2 += w[j] / Float64x2(A(j2, i2 + 1), A(j2 + 1, i2 + 1));
      }
      v[i] = Float64x2(t.x + t.y, t2.x + t2.y);
    }
  }

  void AtAu(Float64x2List u, Float64x2List v, Float64x2List w) {
    Au(u, w);
    atu(w, v);
  }

  double spectralNorm() {
    var u = Float64x2List(n)..fillRange(0, n, Float64x2.splat(1.0)),
        v = Float64x2List(n),
        w = Float64x2List(n),
        vv = Float64x2.zero(),
        vBv = Float64x2.zero();

    for (var i = 0; i < 10; ++i) {
      AtAu(u, v, w);
      AtAu(v, u, w);
    }
    for (var i = 0; i < n; ++i) {
      vBv += u[i] * v[i];
      vv += v[i] * v[i];
    }
    return math.sqrt((vBv.x + vBv.y) / (vv.x + vv.y));
  }
}
