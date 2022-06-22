class EstadoPedido {
  EstadoPedido({
    required this.pagado,
    required this.preparado,
    required this.enviado,
    required this.entregado,
  });

  int pagado;
  int preparado;
  int enviado;
  int entregado;

  factory EstadoPedido.fromJson(Map<String, dynamic> json) => EstadoPedido(
        preparado: json["preparado"],
        enviado: json["enviado"],
        entregado: json["entregado"],
        pagado: json['pagado'],
      );

  Map<String, dynamic> toJson() => {
        "preparado": preparado,
        "enviado": enviado,
        "entregado": entregado,
      };
}
