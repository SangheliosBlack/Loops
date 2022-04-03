
class SearchResult {
  final bool cancelo;
  final bool sugerencia;
  final String placeId;
  final String titulo;
  final double latitud;
  final double longitud;

  SearchResult(
      {this.titulo = '',
      this.placeId = '',
      this.latitud = 54156165,
      this.longitud = 564654564,
      required this.cancelo,
      required this.sugerencia});
}
