import 'dart:math' show cos, sqrt, asin;

double calculateDistance(
    {required num lat1,
    required num lon1,
    required num lat2,
    required num lon2}) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
