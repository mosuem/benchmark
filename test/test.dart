import '../bin/benchmark2_simd.dart' as simd;
import '../bin/benchmark3.dart' as standard;

void main() {
  int n = 100;
  var simdNorm = simd.SpectralNorm(n).spectralNorm();
  var stdNorm = standard.SpectralNorm().approximate(n);
  print(simdNorm - stdNorm == 0);
}
