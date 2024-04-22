import '../bin/benchmark2_simd.dart' as simd;
import '../bin/benchmark3.dart' as standard;

void main() {
  int n = 1000;
  var simdNorm = simd.spectralNorm(n);
  var stdNorm = standard.SpectralNorm().approximate(n);
  print(simdNorm - stdNorm < 0.0001);
}
