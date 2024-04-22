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

void Au(Float64x2List u, Float64x2List w) {
  final len = u.length;
  for (var i = 0; i < len; ++i) {
    var t = Float64x2.zero();
    for (var j = 0; j < len / 2; ++j) {
      t += u[j] / Float64x2(A(i, j), A(i, j + 1));
    }
    w[i] = t;
  }
}

void atu(Float64x2List w, Float64x2List v) {
  final len = w.length;
  for (var i = 0; i < len; ++i) {
    var t = Float64x2.zero();
    for (var j = 0; j < len; ++j) {
      t += w[j] / Float64x2(A(j, i), A(j + 1, i));
    }
    v[i] = t;
  }
}

void AtAu(Float64x2List u, Float64x2List v, Float64x2List w) {
  Au(u, w);
  atu(w, v);
}

double spectralNorm(int n) {
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

void main(List<String> args) {
  final n = args.isNotEmpty ? int.parse(args[0]) : 100;
  print(spectralNorm(n).toStringAsFixed(9));
}
