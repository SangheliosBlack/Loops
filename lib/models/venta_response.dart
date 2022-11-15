import 'dart:convert';

import 'package:delivery/models/cesta.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/ruta.dart';
import 'package:delivery/models/usuario.dart';
import 'package:delivery/models/usuario_venta.dart';

List<Venta> ventaResponseFromJson(String str) =>
    List<Venta>.from(json.decode(str).map((x) => Venta.fromJson(x)));

String ventaToJson(List<Venta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Venta ventoFromJson(String str) => Venta.fromJson(json.decode(str));

class Venta {
  Venta(
      {required this.pedidos,
      required this.id,
      required this.total,
      required this.efectivo,
      required this.envio,
      required this.servicio,
      required this.envioPromo,
      required this.metodoPago,
      required this.createdAt,
      required this.updatedAt,
      required this.v,
      required this.direccion,
      required this.usuario,
      required this.codigoPromo});

  List<PedidoProducto> pedidos;
  String id;
  num total;
  bool efectivo;
  num envio;
  num servicio;
  num envioPromo;
  MetodoPago? metodoPago;
  DateTime createdAt;
  DateTime updatedAt;
  Direccion direccion;
  int v;
  String usuario;
  String codigoPromo;

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        pedidos: List<PedidoProducto>.from(json["pedidos"].map((x) {
          return PedidoProducto.fromJson(x);
        })),
        id: json["_id"],
        total: json["total"],
        efectivo: json["efectivo"],
        envio: json["envio"],
        metodoPago: json['metodoPago'] != null
            ? MetodoPago.fromJson(json["metodoPago"])
            : null,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        direccion: Direccion.fromJson(json["direccion"]),
        usuario: json["usuario"],
        envioPromo: json["envioPromo"],
        servicio: json["servicio"],
        codigoPromo: json["codigo_promo"],
      );

  Map<String, dynamic> toJson() => {
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
        "_id": id,
        "total": total,
        "efectivo": efectivo,
        "gananciaEnvio": envio,
        "direccion": direccion.toJson(),
        "metodoPago": metodoPago?.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "usuario": usuario,
      };
}

class MetodoPago {
  MetodoPago({
    required this.id,
    required this.object,
    required this.amount,
    required this.amountCapturable,
    required this.amountReceived,
    required this.application,
    required this.applicationFeeAmount,
    required this.automaticPaymentMethods,
    required this.canceledAt,
    required this.cancellationReason,
    required this.captureMethod,
    required this.charges,
    required this.clientSecret,
    required this.confirmationMethod,
    required this.created,
    required this.currency,
    required this.customer,
    required this.description,
    required this.invoice,
    required this.lastPaymentError,
    required this.livemode,
    required this.nextAction,
    required this.onBehalfOf,
    required this.paymentMethod,
    required this.paymentMethodOptions,
    required this.paymentMethodTypes,
    required this.processing,
    required this.receiptEmail,
    required this.review,
    required this.setupFutureUsage,
    required this.shipping,
    required this.source,
    required this.statementDescriptor,
    required this.statementDescriptorSuffix,
    required this.status,
    required this.transferData,
    required this.transferGroup,
  });

  String id;
  String object;
  int amount;
  int amountCapturable;
  int amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  dynamic automaticPaymentMethods;
  dynamic canceledAt;
  dynamic cancellationReason;
  String captureMethod;
  Charges charges;
  String clientSecret;
  String confirmationMethod;
  int created;
  String currency;
  String customer;
  dynamic description;
  dynamic invoice;
  dynamic lastPaymentError;
  bool livemode;
  dynamic nextAction;
  dynamic onBehalfOf;
  String paymentMethod;
  PaymentMethodOptions paymentMethodOptions;
  List<String> paymentMethodTypes;
  dynamic processing;
  dynamic receiptEmail;
  dynamic review;
  dynamic setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String status;
  dynamic transferData;
  String transferGroup;

  factory MetodoPago.fromJson(Map<String, dynamic> json) => MetodoPago(
        id: json["id"],
        object: json["object"],
        amount: json["amount"],
        amountCapturable: json["amount_capturable"],
        amountReceived: json["amount_received"],
        application: json["application"],
        applicationFeeAmount: json["application_fee_amount"],
        automaticPaymentMethods: json["automatic_payment_methods"],
        canceledAt: json["canceled_at"],
        cancellationReason: json["cancellation_reason"],
        captureMethod: json["capture_method"],
        charges: Charges.fromJson(json["charges"]),
        clientSecret: json["client_secret"],
        confirmationMethod: json["confirmation_method"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        invoice: json["invoice"],
        lastPaymentError: json["last_payment_error"],
        livemode: json["livemode"],
        nextAction: json["next_action"],
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodOptions:
            PaymentMethodOptions.fromJson(json["payment_method_options"]),
        paymentMethodTypes:
            List<String>.from(json["payment_method_types"].map((x) => x)),
        processing: json["processing"],
        receiptEmail: json["receipt_email"],
        review: json["review"],
        setupFutureUsage: json["setup_future_usage"],
        shipping: json["shipping"],
        source: json["source"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "amount": amount,
        "amount_capturable": amountCapturable,
        "amount_received": amountReceived,
        "application": application,
        "application_fee_amount": applicationFeeAmount,
        "automatic_payment_methods": automaticPaymentMethods,
        "canceled_at": canceledAt,
        "cancellation_reason": cancellationReason,
        "capture_method": captureMethod,
        "charges": charges.toJson(),
        "client_secret": clientSecret,
        "confirmation_method": confirmationMethod,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "invoice": invoice,
        "last_payment_error": lastPaymentError,
        "livemode": livemode,
        "next_action": nextAction,
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_options": paymentMethodOptions.toJson(),
        "payment_method_types":
            List<dynamic>.from(paymentMethodTypes.map((x) => x)),
        "processing": processing,
        "receipt_email": receiptEmail,
        "review": review,
        "setup_future_usage": setupFutureUsage,
        "shipping": shipping,
        "source": source,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.object,
    required this.amount,
    required this.amountCaptured,
    required this.amountRefunded,
    required this.application,
    required this.applicationFee,
    required this.applicationFeeAmount,
    required this.balanceTransaction,
    required this.billingDetails,
    required this.calculatedStatementDescriptor,
    required this.captured,
    required this.created,
    required this.currency,
    required this.customer,
    required this.description,
    required this.destination,
    required this.dispute,
    required this.disputed,
    required this.failureBalanceTransaction,
    required this.failureCode,
    required this.failureMessage,
    required this.invoice,
    required this.livemode,
    required this.onBehalfOf,
    required this.order,
    required this.outcome,
    required this.paid,
    required this.paymentIntent,
    required this.paymentMethod,
    required this.paymentMethodDetails,
    required this.receiptEmail,
    required this.receiptNumber,
    required this.receiptUrl,
    required this.refunded,
    required this.refunds,
    required this.review,
    required this.shipping,
    required this.source,
    required this.sourceTransfer,
    required this.statementDescriptor,
    required this.statementDescriptorSuffix,
    required this.status,
    required this.transferData,
    required this.transferGroup,
  });

  String id;
  String object;
  int amount;
  int amountCaptured;
  int amountRefunded;
  dynamic application;
  dynamic applicationFee;
  dynamic applicationFeeAmount;
  String balanceTransaction;
  BillingDetails billingDetails;
  String calculatedStatementDescriptor;
  bool captured;
  int created;
  String currency;
  String customer;
  dynamic description;
  dynamic destination;
  dynamic dispute;
  bool disputed;
  dynamic failureBalanceTransaction;
  dynamic failureCode;
  dynamic failureMessage;
  dynamic invoice;
  bool livemode;
  dynamic onBehalfOf;
  dynamic order;
  Outcome outcome;
  bool paid;
  String paymentIntent;
  String paymentMethod;
  PaymentMethodDetails paymentMethodDetails;
  dynamic receiptEmail;
  dynamic receiptNumber;
  String receiptUrl;
  bool refunded;
  Charges refunds;
  dynamic review;
  dynamic shipping;
  dynamic source;
  dynamic sourceTransfer;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String status;
  dynamic transferData;
  String transferGroup;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: json["object"],
        amount: json["amount"],
        amountCaptured: json["amount_captured"],
        amountRefunded: json["amount_refunded"],
        application: json["application"],
        applicationFee: json["application_fee"],
        applicationFeeAmount: json["application_fee_amount"],
        balanceTransaction: json["balance_transaction"],
        billingDetails: BillingDetails.fromJson(json["billing_details"]),
        calculatedStatementDescriptor: json["calculated_statement_descriptor"],
        captured: json["captured"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        destination: json["destination"],
        dispute: json["dispute"],
        disputed: json["disputed"],
        failureBalanceTransaction: json["failure_balance_transaction"],
        failureCode: json["failure_code"],
        failureMessage: json["failure_message"],
        invoice: json["invoice"],
        livemode: json["livemode"],
        onBehalfOf: json["on_behalf_of"],
        order: json["order"],
        outcome: Outcome.fromJson(json["outcome"]),
        paid: json["paid"],
        paymentIntent: json["payment_intent"],
        paymentMethod: json["payment_method"],
        paymentMethodDetails:
            PaymentMethodDetails.fromJson(json["payment_method_details"]),
        receiptEmail: json["receipt_email"],
        receiptNumber: json["receipt_number"],
        receiptUrl: json["receipt_url"],
        refunded: json["refunded"],
        refunds: Charges.fromJson(json["refunds"]),
        review: json["review"],
        shipping: json["shipping"],
        source: json["source"],
        sourceTransfer: json["source_transfer"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "amount": amount,
        "amount_captured": amountCaptured,
        "amount_refunded": amountRefunded,
        "application": application,
        "application_fee": applicationFee,
        "application_fee_amount": applicationFeeAmount,
        "balance_transaction": balanceTransaction,
        "billing_details": billingDetails.toJson(),
        "calculated_statement_descriptor": calculatedStatementDescriptor,
        "captured": captured,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "destination": destination,
        "dispute": dispute,
        "disputed": disputed,
        "failure_balance_transaction": failureBalanceTransaction,
        "failure_code": failureCode,
        "failure_message": failureMessage,
        "invoice": invoice,
        "livemode": livemode,
        "on_behalf_of": onBehalfOf,
        "order": order,
        "outcome": outcome.toJson(),
        "paid": paid,
        "payment_intent": paymentIntent,
        "payment_method": paymentMethod,
        "payment_method_details": paymentMethodDetails.toJson(),
        "receipt_email": receiptEmail,
        "receipt_number": receiptNumber,
        "receipt_url": receiptUrl,
        "refunded": refunded,
        "refunds": refunds.toJson(),
        "review": review,
        "shipping": shipping,
        "source": source,
        "source_transfer": sourceTransfer,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class Charges {
  Charges({
    required this.object,
    required this.data,
    required this.hasMore,
    required this.totalCount,
    required this.url,
  });

  String object;
  List<Datum> data;
  bool hasMore;
  int totalCount;
  String url;

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        object: json["object"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class BillingDetails {
  BillingDetails({
    required this.address,
    this.email,
    this.name,
    this.phone,
  });

  Address address;
  dynamic email;
  dynamic name;
  dynamic phone;

  factory BillingDetails.fromJson(Map<String, dynamic> json) => BillingDetails(
        address: Address.fromJson(json["address"]),
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "email": email,
        "name": name,
        "phone": phone,
      };
}

class Address {
  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  dynamic city;
  dynamic country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

class Outcome {
  Outcome({
    required this.networkStatus,
    required this.reason,
    required this.riskLevel,
    required this.riskScore,
    required this.sellerMessage,
    required this.type,
  });

  String networkStatus;
  dynamic reason;
  String riskLevel;
  int riskScore;
  String sellerMessage;
  String type;

  factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
        networkStatus: json["network_status"],
        reason: json["reason"],
        riskLevel: json["risk_level"],
        riskScore: json["risk_score"],
        sellerMessage: json["seller_message"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "network_status": networkStatus,
        "reason": reason,
        "risk_level": riskLevel,
        "risk_score": riskScore,
        "seller_message": sellerMessage,
        "type": type,
      };
}

class PaymentMethodDetails {
  PaymentMethodDetails({
    required this.card,
    required this.type,
  });

  PaymentMethodDetailsCard card;
  String type;

  factory PaymentMethodDetails.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetails(
        card: PaymentMethodDetailsCard.fromJson(json["card"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "card": card.toJson(),
        "type": type,
      };
}

class PaymentMethodDetailsCard {
  PaymentMethodDetailsCard({
    required this.brand,
    required this.checks,
    required this.country,
    required this.expMonth,
    required this.expYear,
    required this.fingerprint,
    required this.funding,
    required this.installments,
    required this.last4,
    required this.mandate,
    required this.network,
    required this.threeDSecure,
    required this.wallet,
  });

  String brand;
  Checks checks;
  String country;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  dynamic installments;
  String last4;
  dynamic mandate;
  String network;
  dynamic threeDSecure;
  dynamic wallet;

  factory PaymentMethodDetailsCard.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetailsCard(
        brand: json["brand"],
        checks: Checks.fromJson(json["checks"]),
        country: json["country"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        fingerprint: json["fingerprint"],
        funding: json["funding"],
        installments: json["installments"],
        last4: json["last4"],
        mandate: json["mandate"],
        network: json["network"],
        threeDSecure: json["three_d_secure"],
        wallet: json["wallet"],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "checks": checks.toJson(),
        "country": country,
        "exp_month": expMonth,
        "exp_year": expYear,
        "fingerprint": fingerprint,
        "funding": funding,
        "installments": installments,
        "last4": last4,
        "mandate": mandate,
        "network": network,
        "three_d_secure": threeDSecure,
        "wallet": wallet,
      };
}

class Checks {
  Checks({
    this.addressLine1Check,
    this.addressPostalCodeCheck,
    this.cvcCheck,
  });

  dynamic addressLine1Check;
  dynamic addressPostalCodeCheck;
  dynamic cvcCheck;

  factory Checks.fromJson(Map<String, dynamic> json) => Checks(
        addressLine1Check: json["address_line1_check"],
        addressPostalCodeCheck: json["address_postal_code_check"],
        cvcCheck: json["cvc_check"],
      );

  Map<String, dynamic> toJson() => {
        "address_line1_check": addressLine1Check,
        "address_postal_code_check": addressPostalCodeCheck,
        "cvc_check": cvcCheck,
      };
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    required this.card,
  });

  PaymentMethodOptionsCard card;

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: PaymentMethodOptionsCard.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "card": card.toJson(),
      };
}

class PaymentMethodOptionsCard {
  PaymentMethodOptionsCard({
    this.installments,
    this.mandateOptions,
    this.network,
    required this.requestThreeDSecure,
  });

  dynamic installments;
  dynamic mandateOptions;
  dynamic network;
  String requestThreeDSecure;

  factory PaymentMethodOptionsCard.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptionsCard(
        installments: json["installments"],
        mandateOptions: json["mandate_options"],
        network: json["network"],
        requestThreeDSecure: json["request_three_d_secure"],
      );

  Map<String, dynamic> toJson() => {
        "installments": installments,
        "mandate_options": mandateOptions,
        "network": network,
        "request_three_d_secure": requestThreeDSecure,
      };
}

List<PedidoProducto> pedidoProductoFromJson(String str) =>
    List<PedidoProducto>.from(
        json.decode(str).map((x) => PedidoProducto.fromJson(x)));

class PedidoProducto {
  PedidoProducto(
      {required this.productos,
      required this.id,
      required this.total,
      required this.tienda,
      required this.repartidor,
      required this.imagen,
      required this.confirmado,
      required this.efectivo,
      required this.usuario,
      required this.createdAt,
      required this.updatedAt,
      required this.entregadoRepartidor,
      required this.entregadoCliente,
      required this.confirmacionTiempo,
      required this.codigoRepartidor,
      required this.codigoCliente,
      required this.entregadoRepartidorTiempo,
      required this.entregadoClienteTiempo,
      required this.idVenta,
      required this.repartidorCalificado,
      required this.repartidorDomicilio,
      required this.repartidorCalificadoTiempo,
      required this.repartidorDomicilioTiempo,
      required this.envio,
      required this.direccionNegocio,
      required this.direccionCliente,
      required this.ruta,
      required this.tiempoEspera});

  List<Producto> productos;
  String id;
  int total;
  String tienda;
  Usuario repartidor;
  String imagen;
  bool confirmado;
  bool efectivo;
  num envio;
  UsuarioVenta usuario;
  DateTime createdAt;
  bool entregadoRepartidor;
  bool entregadoCliente;
  DateTime confirmacionTiempo;
  DateTime entregadoRepartidorTiempo;
  DateTime entregadoClienteTiempo;
  String codigoRepartidor;
  String codigoCliente;
  String idVenta;
  Direccion direccionNegocio;
  Direccion direccionCliente;

  bool repartidorDomicilio;
  bool repartidorCalificado;
  Ruta ruta;

  DateTime repartidorDomicilioTiempo;
  DateTime repartidorCalificadoTiempo;

  DateTime updatedAt;
  int tiempoEspera;

  factory PedidoProducto.fromJson(Map<String, dynamic> json) {
    return PedidoProducto(
      ruta: Ruta.fromJson(json['ruta']),
      direccionCliente: Direccion.fromJson(json['direccion_cliente']),
      direccionNegocio: Direccion.fromJson(json['direccion_negocio']),
      envio: json['envio'],
      repartidorCalificado: json['repartidor_calificado'],
      repartidorDomicilio: json['repartidor_domicilio'],
      entregadoCliente: json['entregado_cliente'],
      codigoCliente: json['codigo_cliente'],
      idVenta: json['id_venta'],
      codigoRepartidor: json['codigo_repartidor'],
      productos: List<Producto>.from(
          json["productos"].map((x) => Producto.fromJson(x))),
      id: json["_id"],
      total: json["total"],
      tienda: json["tienda"],
      confirmacionTiempo: json['confirmacion_tiempo'] != null
          ? DateTime.parse(json["confirmacion_tiempo"])
          : DateTime(0000, 00, 00, 00, 00),
      entregadoRepartidorTiempo: json['entrega_repartidor_tiempo'] != null
          ? DateTime.parse(json["entrega_repartidor_tiempo"])
          : DateTime(0000, 00, 00, 00, 00),
      repartidorCalificadoTiempo: json['repartidor_calificado_tiempo'] != null
          ? DateTime.parse(json["repartidor_calificado_tiempo"])
          : DateTime(0000, 00, 00, 00, 00),
      repartidorDomicilioTiempo: json['repartidor_domicilio_tiempo'] != null
          ? DateTime.parse(json["repartidor_domicilio_tiempo"])
          : DateTime(0000, 00, 00, 00, 00),
      entregadoClienteTiempo: json['entrega_cliente_tiempo'] != null
          ? DateTime.parse(json["entrega_cliente_tiempo"])
          : DateTime(0000, 00, 00, 00, 00),
      repartidor: json['repartidor'] != null
          ? Usuario.fromJson(json["repartidor"])
          : Usuario(
              codigo: '',
              online: false,
              direcciones: [],
              correo: '',
              nombreUsuario: '',
              nombre: '',
              socio: false,
              createdAt: DateTime(2017, 9, 7, 17, 30),
              updatedAt: DateTime(2017, 9, 7, 17, 30),
              uid: '',
              negocios: [],
              numeroCelular: '',
              customerID: '',
              nombreCodigo: '',
              idCodigo: '',
              dialCode: '',
              repartidor: false,
              ultimaTarea: DateTime(2017, 9, 7, 17, 30),
              transito: false,
              cesta: Cesta(
                  productos: [],
                  total: 0,
                  tarjeta: '',
                  direccion: Direccion(
                      id: '',
                      coordenadas: Coordenadas(lat: 6454564, lng: 65465),
                      predeterminado: false,
                      titulo: ''),
                  efectivo: false,
                  codigo: ''),
              onlineRepartidor: false),
      imagen: json["imagen"],
      confirmado: json["confirmado"],
      efectivo: json['efectivo'],
      usuario: UsuarioVenta.fromJson(json['usuario']),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      tiempoEspera: json['tiempo_espera'],
      entregadoRepartidor: json['entregado_repartidor'],
    );
  }

  Map<String, dynamic> toJson() => {
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "_id": id,
        "total": total,
        "tienda": tienda,
        "repartidor": repartidor,
        "imagen": imagen,
        "confirmado": confirmado,
      };
}

class Ubicacion {
  Ubicacion({required this.latitud, required this.longitud, required this.id});

  double latitud;
  double longitud;
  String id;

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "latitud": latitud,
        "longitud": longitud,
        "_id": id,
      };
}
