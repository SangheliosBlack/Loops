import 'package:delivery/models/eleccion_model.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

Future<List<int>> testTicket(
    PaperSize paper, CapabilityProfile profile, PedidoProducto pedido) async {
  final Generator generator = Generator(paper, profile, spaceBetweenRows: 10);

  List<int> bytes = [];

  String formattedDate =
      DateFormat.yMd('es-MX').add_jm().format(pedido.createdAt);

  final nombre = pedido.usuario.nombre.split(' ');

  bytes += generator.feed(1);

  bytes += generator.setGlobalFont(PosFontType.fontA);

  bytes += generator.text(
    pedido.tienda,
    styles: const PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
    ),
    linesAfter: 1,
  );
  bytes += generator.text(pedido.direccion,
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.hr();

  bytes += generator.row([
    PosColumn(text: 'Cliente', width: 3, styles: const PosStyles(reverse: true)),
    PosColumn(
        text: nombre[0],
        width: 9,
        styles: const PosStyles(
          reverse: true,
          align: PosAlign.right,
        )),
  ]);

  bytes += generator.hr();

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
          width: 9,
          styles: const PosStyles()),
      PosColumn(
          text: '\$ ${(element.precio * element.cantidad).toStringAsFixed(2)}',
          width: 3,
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
        PosColumn(text: '', width: 1),
        PosColumn(text: '${element.cantidad} ${element3.titulo}', width: 8),
        PosColumn(
            text: element3.valor
                ? '\$ ${(element3.precio * element.cantidad).toStringAsFixed(2)}'
                : '',
            width: 3,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
  }

  bytes += generator.hr();

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

  bytes += generator.hr(ch: '=', linesAfter: 1);

  bytes += generator.text(
    formattedDate,
    styles: const PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ),
    linesAfter: 0,
  );

  bytes += generator.text(
    '${nombre[0]} gracias por tu pedido en Capitan Naza <3',
    styles: const PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ),
    linesAfter: 1,
  );

  bytes += generator.qrcode(pedido.id, size: QRSize.Size8);

  bytes += generator.feed(0);

  bytes += generator.beep();

  bytes += generator.cut();
  return bytes;
}
