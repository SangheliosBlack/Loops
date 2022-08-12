class EstadoPedido {
  EstadoPedido({
    required this.pagado,
    required this.preparado,
    required this.enviado,
    required this.entregado,
    required this.confirmado,
  });

  int pagado;
  int preparado;
  int enviado;
  int entregado;
  int confirmado;

  factory EstadoPedido.fromJson(Map<String, dynamic> json) => EstadoPedido(
        confirmado: json["confirmado"],
        preparado: json["preparado"],
        enviado: json["enviado"],
        entregado: json["entregado"],
        pagado: json['pagado'],
      );

  Map<String, dynamic> toJson() => {
        "confirmado": confirmado,
        "preparado": preparado,
        "enviado": enviado,
        "entregado": entregado,
      };
}
