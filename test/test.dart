import '../bin/benchmark2_simd.dart' as simd;
import '../bin/benchmark3.dart' as standard2;
import '../bin/benchmark2.dart' as standard;

void main() {
  int n = 1000;
  var simdNorm = simd.SpectralNorm(n).spectralNorm();
  var stdNorm = standard.spectralNorm(n);
  var std2Norm = standard2.SpectralNorm().approximate(n);
  print(simdNorm - stdNorm);
  print(simdNorm - std2Norm);
  print(std2Norm - stdNorm);
}
