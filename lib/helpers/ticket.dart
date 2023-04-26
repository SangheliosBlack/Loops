import 'package:delivery/models/abono.dart';
import 'package:delivery/models/eleccion_model.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

Future<List<int>> testTicket(
    {required bool tiendaRopa,
    String abono = '0.00',
    String entregado = '0.00',
    bool liquidado = false,
    bool newDate = false,
    required PaperSize paper,
    required CapabilityProfile profile,
    required PedidoProducto pedido}) async {
  final Generator generator = Generator(paper, profile, spaceBetweenRows: 10);

  List<int> bytes = [];

  final now = DateTime.now();

  String precio = abono.replaceAll('\$', '');
  precio = precio.replaceAll(' ', '');
  precio = precio.replaceAll(',', '');

  String precio2 = entregado.replaceAll('\$', '');
  precio2 = precio2.replaceAll(' ', '');
  precio2 = precio2.replaceAll(',', '');

  String formattedDate = DateFormat.yMd('es-MX')
      .add_jm()
      .format(newDate ? now.toLocal() : pedido.createdAt.toLocal());

  final nombre = pedido.usuario.nombre.split(' ');

  num calcularAbonos({required List<Abono> abonos}) {
    var valores = abonos.fold<num>(0, (previousValue, element) {
      return previousValue + element.cantidad;
    });
    return valores;
  }

  bytes += generator.feed(1);

  bytes += generator.setGlobalFont(PosFontType.fontA);

  // final ByteData data = await rootBundle.load('assets/images/impresion1.png');
  // final Uint8List buf = data.buffer.asUint8List();
  // final Image image = decodeImage(buf)!;

  bytes += generator.feed(1);

  bytes += generator.text(
    pedido.tienda,
    styles: const PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
    ),
    linesAfter: 1,
  );
  bytes += generator.text(pedido.direccionNegocio.titulo,
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.hr();

  if (tiendaRopa == false) {
    bytes += generator.row([
      PosColumn(
          text: 'Cliente', width: 3, styles: const PosStyles(reverse: true)),
      PosColumn(
          text: nombre[0],
          width: 9,
          styles: const PosStyles(
            reverse: true,
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr();
  }

  bytes += generator.row([
    PosColumn(text: 'Producto', width: 9),
    PosColumn(
        text: 'Total',
        width: 3,
        styles: const PosStyles(align: PosAlign.right)),
  ]);

  bytes += generator.emptyLines(1);

  for (var element in pedido.productos) {
    bytes += generator.row([
      PosColumn(
          text: '${element.cantidad} x ${element.nombre}',
          width: 8,
          styles: const PosStyles()),
      PosColumn(
          text: '\$ ${(element.precio * element.cantidad).toStringAsFixed(2)}',
          width: 4,
          styles: const PosStyles(align: PosAlign.right)),
    ]);

    List<EleccionModel> listado = [];

    for (var i = 0; i < element.opciones.length; i++) {
      try {
        var contador = 0;
        for (var element2 in element.opciones[i].listado) {
          if (element2.activo) {
            contador++;
            var eleccion = EleccionModel(
                titulo: element2.tipo,
                precio: element2.precio,
                valor: element2.fijo || contador > element.opciones[i].minimo
                    ? true
                    : false);
            listado.insert(0, eleccion);
          }
        }

        // ignore: empty_catches
      } catch (e) {}
    }

    listado.sort(((a, b) {
      if (b.valor) {
        return 1;
      }
      return -1;
    }));

    for (var element3 in listado) {
      bytes += generator.row([
        PosColumn(text: '', width: 2),
        PosColumn(text: '- ${element3.titulo}', width: 7),
        PosColumn(
            text: element3.valor
                ? '\$ ${(element3.precio * element.cantidad).toStringAsFixed(2)}'
                : '',
            width: 3,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
  }

  bytes += generator.hr(ch: '=');

  bytes += generator.row([
    PosColumn(
        text: 'TOTAL',
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        )),
    PosColumn(
        text: '\$ ${pedido.total.toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        )),
  ]);

  bytes += generator.row([
    PosColumn(text: 'EFECTIVO', width: 6),
    PosColumn(
        text: '\$ ${num.parse(precio2).toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right)),
  ]);

  bytes += generator.row([
    PosColumn(text: 'CAMBIO', width: 6),
    PosColumn(
        text:
            '\$ ${(num.parse(precio2) - num.parse(precio)).toStringAsFixed(2)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right)),
  ]);

  bytes += generator.hr(ch: '=', linesAfter: 1);

  if (!liquidado) {
    bytes += generator.row([
      PosColumn(text: 'SALDO INICIAL', width: 6),
      PosColumn(
          text: '\$ ${pedido.total.toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'SALDO ANTERIOR', width: 6),
      PosColumn(
          text:
              '\$ ${calcularAbonos(abonos: pedido.abonos) <= 0 ? pedido.total.toStringAsFixed(2) : calcularAbonos(abonos: pedido.abonos).toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'ABONO', width: 6),
      PosColumn(
          text: '\$ ${num.parse(precio).toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'SALDO ACTUAL', width: 6),
      PosColumn(
          text:
              '\$ ${(pedido.total - calcularAbonos(abonos: pedido.abonos) - num.parse(precio)).toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);
  }

  bytes += generator.text(
    formattedDate,
    styles: const PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ),
    linesAfter: 0,
  );

  if (tiendaRopa == false) {
    bytes += generator.text(
      '${nombre[0]}, gracias por tu pedido en Capitan Naza <3',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    );
  } else {
    bytes += generator.text(
      'Cambios y apartados maximo 15 dias despues de la compra.',
      styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size6,
          width: PosTextSize.size6),
      linesAfter: 1,
    );
  }

  bytes += generator.qrcode(tiendaRopa ? pedido.idVenta : pedido.id,
      size: QRSize.Size8);

  bytes += generator.feed(0);

  bytes += generator.beep();

  bytes += generator.cut();
  return bytes;
}

Future<List<int>> testTicket2(
  PaperSize paper,
  CapabilityProfile profile,
) async {
  final Generator generator = Generator(paper, profile, spaceBetweenRows: 10);

  List<int> bytes = [];

  // bytes += generator.feed(3);

  bytes += generator.setGlobalFont(PosFontType.fontA);

  // bytes += generator.text(
  //   'Talla',
  //   styles: const PosStyles(
  //       align: PosAlign.center,
  //       bold: false,
  //       width: PosTextSize.size8,
  //       height: PosTextSize.size8),
  //   linesAfter: 0,
  // );

  // bytes += generator.row([
  //   PosColumn(
  //       text: 'XS',
  //       width: 2,
  //       styles: const PosStyles(
  //         reverse: false,
  //         bold: false,
  //         align: PosAlign.center,
  //       )),
  //   PosColumn(
  //       text: 'S',
  //       width: 2,
  //       styles: const PosStyles(reverse: false, align: PosAlign.center)),
  //   PosColumn(
  //       text: 'M',
  //       width: 2,
  //       styles: const PosStyles(reverse: true, align: PosAlign.center)),
  //   PosColumn(
  //       text: 'L',
  //       width: 2,
  //       styles: const PosStyles(reverse: false, align: PosAlign.center)),
  //   PosColumn(
  //       text: 'XL',
  //       width: 2,
  //       styles: const PosStyles(reverse: false, align: PosAlign.center)),
  //   PosColumn(
  //       text: 'NA',
  //       width: 2,
  //       styles: const PosStyles(reverse: false, align: PosAlign.center)),
  // ]);

  // bytes += generator.hr(ch: '-', linesAfter: 0);

  // bytes += generator.row([
  //   PosColumn(
  //     text: 'M',
  //     width: 12,
  //     styles: const PosStyles(
  //       align: PosAlign.center,
  //     ),
  //   ),
  // ]);

  // bytes += generator.feed(1);

  // bytes += generator.text(
  //   'Escanea y compra',
  //   styles: const PosStyles(align: PosAlign.center, bold: false),
  //   linesAfter: 0,
  // );
  // bytes += generator.text(
  //   'con Nombre del negocio',
  //   styles: const PosStyles(
  //     align: PosAlign.center,
  //   ),
  //   linesAfter: 0,
  // );

  // bytes += generator.feed(1);

  bytes += generator.barcode(Barcode.upcA([1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4]),
      height: 60);

  bytes += generator.feed(1);

  bytes += generator.text(
    '599.000',
    styles: const PosStyles(
      align: PosAlign.center,
    ),
    linesAfter: 0,
  );

  // bytes += generator.feed(3);

  // bytes += generator.text(
  //   'Nombre del negocio',
  //   styles: const PosStyles(
  //     align: PosAlign.center,
  //   ),
  //   linesAfter: 0,
  // );

  bytes += generator.beep();

  bytes += generator.cut();
  return bytes;
}
