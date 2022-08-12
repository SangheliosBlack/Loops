import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/stripe_service.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:delivery/service/ventas_service.dart';
import 'package:delivery/views/extras/direcciones_seleccion.dart';
import 'package:delivery/views/extras/done.dart';
import 'package:delivery/views/extras/metodo_predeterminado.dart';
import 'package:delivery/views/extras/nuevo_metodo.dart';
import 'package:delivery/views/extras/ver_producto.dart';
import 'package:delivery/widgets/direcciones_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:delivery/extensions/extensions.dart';

class SectionOrder extends StatelessWidget {
  final String titulo;
  final Widget child;

  final bool isPainted;
  const SectionOrder(
      {Key? key,
      required this.child,
      required this.titulo,
      this.isPainted = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(
          top: 15,
          left: titulo == 'Direccion envio' ? 0 : 25,
          right: titulo == 'Direccion envio' ? 0 : 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: titulo == 'Direccion envio' ? 25 : 0,
                right: titulo == 'Direccion envio' ? 25 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.quicksand(
                      color: Colors.black.withOpacity(.7), fontSize: 20),
                ),
                titulo == 'Direccion envio'
                    ? direccionesService.direcciones.length > 1
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              direccionSeleccion(context);
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Cambiar',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black.withOpacity(.8)),
                                )),
                          )
                        : GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              navigationService.navegarDraw(
                                  ruta: '/drawer/direcciones');
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Agregar',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black.withOpacity(.8)),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    )
                                  ],
                                )),
                          )
                    : titulo == 'Resumen de orden' &&
                            authService.usuario.cesta.productos.isNotEmpty
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              mostrarCarga(context);
                              await authService.eliminarCesta();
                              Navigator.pop(context);
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor:
                                    const Color.fromRGBO(0, 0, 0, 1),
                                content: Text(
                                  'Cesta eliminada',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                  ),
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Eliminar todo',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black.withOpacity(.8)),
                                )),
                          )
                        : Container()
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration:
                isPainted ? Styles.containerCustom() : const BoxDecoration(),
            child: child,
          ),
        ],
      ),
    );
  }

  direccionSeleccion(BuildContext context) async {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        backgroundColor: Colors.white,
        elevation: 0,
        builder: (builder) {
          return const DireccionesSeleccion();
        });
  }
}

class OrderItems extends StatelessWidget {
  const OrderItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final pantallaService = Provider.of<LlenarPantallasService>(context);
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => item(
              context,
              authService.usuario.cesta.productos[index],
              index,
              pantallaService.tiendas.firstWhere((element) =>
                  element.nombre ==
                  authService.usuario.cesta.productos[index].tienda)),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 0);
          },
          itemCount: authService.usuario.cesta.productos.length),
    );
  }

  Widget item(
      BuildContext context, Producto producto, int index, Tienda tienda) {
    final authService = Provider.of<AuthService>(context);
    final pantallasService = Provider.of<LlenarPantallasService>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerProductoView(
                    producto: producto,
                    tienda: pantallasService.tiendas.firstWhere(
                        (element) => element.nombre == producto.tienda),
                  )),
        );
      },
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 800),
            child: tienda.online != false
                ? Container()
                : Column(
                    children: [
                      Container(
                        height: 15,
                      ),
                      Text(
                        '${tienda.nombre} se encuentra fuera de servicio, para continuar debes eliminar ente producto de tu cesta.',
                        style: GoogleFonts.quicksand(color: Colors.red),
                      ),
                      Container(
                        height: 15,
                      )
                    ],
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 95,
                  width: 95,
                  child: Hero(
                    tag: producto.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          imageUrl:
                              'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg',
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(.15),
                                      BlendMode.color,
                                    ),
                                  ),
                                ),
                              ),
                          placeholder: (context, url) => Container(
                              padding: const EdgeInsets.all(30),
                              child: const CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.black,
                              )),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error);
                          }),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 95,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              producto.tienda,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: Colors.blue,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              producto.nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: Colors.black.withOpacity(.8),
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          elecciones(producto: producto),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                              color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text('\$',
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(.8))),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                    ((producto.precio + producto.extra) *
                                            producto.cantidad)
                                        .toStringAsFixed(2),
                                    style: GoogleFonts.quicksand(
                                        fontSize: 24,
                                        color: Colors.black.withOpacity(.8))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        mostrarCarga(context);
                        await authService.eliminarProductoCesta(pos: index);
                        Navigator.pop(context);
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                          content: Text(
                            '${producto.nombre} eliminado',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                            ),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 13),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 27),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 1,
                                color: pantallasService.tiendas
                                        .firstWhere((element) =>
                                            element.nombre == producto.tienda)
                                        .online
                                    ? Colors.grey.withOpacity(.1)
                                    : Colors.red)),
                        child: Text(
                          'Eliminar',
                          style: GoogleFonts.quicksand(
                              color: pantallasService.tiendas
                                      .firstWhere((element) =>
                                          element.nombre == producto.tienda)
                                      .online
                                  ? Colors.black.withOpacity(.8)
                                  : Colors.red),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (producto.cantidad == 1) {
                              mostrarCarga(context);
                              await authService.eliminarProductoCesta(
                                  pos: index);
                              Navigator.pop(context);
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor:
                                    const Color.fromRGBO(0, 0, 0, 1),
                                content: Text(
                                  '${producto.nombre} eliminado',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                  ),
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              mostrarCarga(context);
                              await authService.actulizarCantidad(
                                  cantidad: (producto.cantidad - 1).toInt(),
                                  index: index);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: producto.cantidad == 1
                                      ? Colors.red.withOpacity(.05)
                                      : const Color(0xffF3F5F6)
                                          .withOpacity(.5)),
                              child: Icon(
                                producto.cantidad == 1
                                    ? Icons.delete
                                    : Icons.remove,
                                size: 16,
                                color: producto.cantidad != 1
                                    ? Colors.grey.withOpacity(.7)
                                    : Colors.red.withOpacity(.5),
                              )),
                        ),
                        Container(
                            width: 37,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: Text(
                                producto.cantidad.toString(),
                                style: GoogleFonts.quicksand(fontSize: 20),
                              ),
                            )),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: producto.cantidad < 15
                              ? () async {
                                  mostrarCarga(context);
                                  await authService.actulizarCantidad(
                                      cantidad: (producto.cantidad + 1).toInt(),
                                      index: index);
                                  Navigator.pop(context);
                                }
                              : () {
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                    content: Text(
                                      'Cantidad maxima alcanzada',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(234, 248, 248, 1)),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Color.fromRGBO(62, 204, 191, 1),
                              )),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String elecciones({required Producto producto}) {
    String valor = '';

    for (var i = 0; i < producto.opciones.length; i++) {
      try {
        for (var element in producto.opciones[i].listado) {
          if (element.activo) {
            if (valor.isEmpty) {
              valor = element.tipo;
            } else {
              valor = valor + '  |  ' + element.tipo;
            }
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }

    return valor;
  }
}

class DeliveryOptionsContainer extends StatelessWidget {
  const DeliveryOptionsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    final sugerencia = Provider.of<PermissionStatusProvider>(context);

    return direccionesService.direcciones.isNotEmpty
        ? direccionFavorita(direccionesService, context)
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              if (sugerencia.listaSugerencias.isEmpty) {
                calculandoAlerta(context);
                try {
                  if (sugerencia.listaSugerencias.isEmpty) {
                    await sugerencia.ubicacionActual();
                  }
                  final resultado = await showSearch(
                      context: context, delegate: SearchDestination());
                  if (resultado!.cancelo == false) {
                    retornoBusqueda(resultado, direccionesService, context);
                  }
                } catch (e) {
                  debugPrint('Ningun lugar seleccionado');
                }
                Navigator.pop(context);
              } else {
                try {
                  final resultado = await showSearch(
                      context: context, delegate: SearchDestination());
                  if (resultado!.cancelo == false) {
                    retornoBusqueda(resultado, direccionesService, context);
                  }
                } catch (e) {
                  debugPrint('Ningun lugar seleccionado');
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Agregar nueva direccion',
                      style: GoogleFonts.quicksand(color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue[50]),
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          );
  }

  DireccionBuildWidget direccionFavorita(
      DireccionesService direccionesService, BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return DireccionBuildWidget(
      direccion: direccionesService.direcciones[
          authService.usuario.cesta.direccion.titulo != ''
              ? direccionesService.direcciones.indexWhere((element) =>
                  authService.usuario.cesta.direccion.titulo == element.titulo)
              : obtenerFavorito(direccionesService.direcciones) != -1
                  ? obtenerFavorito(direccionesService.direcciones)
                  : 0],
    );
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }

  void retornoBusqueda(SearchResult result,
      DireccionesService direccionesService, BuildContext context) async {
    calculandoAlerta(context);
    await Future.delayed(const Duration(milliseconds: 1500));

    final String titulo = result.titulo;
    final double latitud = result.latitud;
    final double longitud = result.longitud;
    final String id = result.placeId;

    final nuevaDireccion = await direccionesService.agregarNuevaDireccion(
        id: id, latitud: latitud, longitud: longitud, titulo: titulo);
    if (nuevaDireccion) {
      Navigator.pop(context);
    } else {
      /**IMPLEMENTAR ALGO ERROR*/
    }
  }
}

class PaymenthMethodsFinal extends StatelessWidget {
  const PaymenthMethodsFinal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: Styles.containerCustom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No tienes nigun metodo de pago',
            style: Styles.letterCustom(12, false, .6),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //PENDIENTE
              },
              child:
                  Text('Agregar', style: Styles.letterCustom(14, true, -0.1)),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }
}

class PaymentSummary extends StatefulWidget {
  final ScrollController controller;

  const PaymentSummary({Key? key, required this.controller}) : super(key: key);

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  @override
  Widget build(BuildContext context) {
    final tarjetasService = Provider.of<TarjetasService>(context);
    final customerService = Provider.of<StripeService>(context);
    final pantallaService = Provider.of<LlenarPantallasService>(context);
    final direccionesService = Provider.of<DireccionesService>(context);
    final authService = Provider.of<AuthService>(context, listen: true);
    final pedidosService = Provider.of<PedidosService>(context, listen: true);

    final busqueda = tarjetasService.listaTarjetas.indexWhere(
        (element) => element.id == customerService.tarjetaPredeterminada);
    final busqueda2 = tarjetasService.listaTarjetas.indexWhere(
        (element) => element.id == authService.usuario.cesta.tarjeta);

    final controller = TextEditingController();
    final nombre = authService.usuario.nombreCodigo.split(' ');

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(0),
      decoration: Styles.containerCustom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Metodo de pago',
                style:
                    GoogleFonts.quicksand(color: Colors.black.withOpacity(.8)),
              ),
              tarjetasService.listaTarjetas.length > 1
                  ? GestureDetector(
                      onTap: () {
                        metodoPredeterminado(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              'Cambiar tarjeta',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8)),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.style_outlined,
                                color: Colors.black),
                            const SizedBox(width: 2),
                          ],
                        ),
                      ),
                    )
                  : AnimatedOpacity(
                      duration: const Duration(microseconds: 1),
                      opacity: 0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Text(
                                'Agregar',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black.withOpacity(.8)),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.add,
                                color: Colors.grey,
                              )
                            ],
                          )),
                    )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tarjetasService.listaTarjetas.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 65,
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  decoration: BoxDecoration(
                                      color: busqueda2 != -1
                                          ? tarjetasService
                                                      .listaTarjetas[busqueda2]
                                                      .card
                                                      .brand ==
                                                  'visa'
                                              ? const Color.fromRGBO(
                                                  232, 241, 254, 1)
                                              : const Color.fromRGBO(
                                                  251, 231, 220, 1)
                                          : tarjetasService
                                                      .listaTarjetas[
                                                          busqueda != -1
                                                              ? busqueda
                                                              : 0]
                                                      .card
                                                      .brand ==
                                                  'visa'
                                              ? const Color.fromRGBO(
                                                  232, 241, 254, 1)
                                              : const Color.fromRGBO(
                                                  251, 231, 220, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        height: 55,
                                        width: 55,
                                        child: SvgPicture.asset(
                                          busqueda2 != -1
                                              ? tarjetasService
                                                          .listaTarjetas[
                                                              busqueda2]
                                                          .card
                                                          .brand ==
                                                      'visa'
                                                  ? 'assets/images/visa_color.svg'
                                                  : 'assets/images/mc.svg'
                                              : tarjetasService
                                                          .listaTarjetas[
                                                              busqueda != -1
                                                                  ? busqueda
                                                                  : 0]
                                                          .card
                                                          .brand ==
                                                      'visa'
                                                  ? 'assets/images/visa_color.svg'
                                                  : 'assets/images/mc.svg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            busqueda2 != -1
                                                ? (tarjetasService
                                                        .listaTarjetas[
                                                            busqueda2]
                                                        .card
                                                        .brand)
                                                    .capitalize()
                                                : (tarjetasService
                                                        .listaTarjetas[
                                                            busqueda != -1
                                                                ? busqueda
                                                                : 0]
                                                        .card
                                                        .brand)
                                                    .capitalize(),
                                            style: GoogleFonts.quicksand(
                                              fontSize: 17,
                                              color:
                                                  Colors.black.withOpacity(1),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            busqueda2 != -1
                                                ? tarjetasService
                                                            .listaTarjetas[
                                                                busqueda2]
                                                            .id ==
                                                        customerService
                                                            .tarjetaPredeterminada
                                                    ? 'Predeterminada'
                                                    : ''
                                                : tarjetasService
                                                            .listaTarjetas[
                                                                busqueda != -1
                                                                    ? busqueda
                                                                    : 0]
                                                            .id ==
                                                        customerService
                                                            .tarjetaPredeterminada
                                                    ? 'Predeterminada'
                                                    : '',
                                            style: GoogleFonts.quicksand(
                                              fontSize: 11,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            busqueda2 != -1
                                                ? tarjetasService
                                                            .listaTarjetas[
                                                                busqueda2]
                                                            .card
                                                            .funding ==
                                                        'credit'
                                                    ? 'Tarjeta Credito'
                                                    : 'Tarjeta Debito'
                                                : tarjetasService
                                                            .listaTarjetas[
                                                                busqueda != -1
                                                                    ? busqueda
                                                                    : 0]
                                                            .card
                                                            .funding ==
                                                        'credit'
                                                    ? 'Tarjeta Credito'
                                                    : 'Tarjeta Debito',
                                            style: GoogleFonts.quicksand(
                                              fontSize: 14,
                                              color: Colors.grey.withOpacity(1),
                                            )),
                                        const SizedBox(width: 4),
                                        Text(
                                            busqueda2 != -1
                                                ? tarjetasService
                                                    .listaTarjetas[busqueda2]
                                                    .card
                                                    .last4
                                                : tarjetasService
                                                    .listaTarjetas[
                                                        busqueda != -1
                                                            ? busqueda
                                                            : 0]
                                                    .card
                                                    .last4,
                                            style: GoogleFonts.quicksand(
                                              fontSize: 14,
                                              color: Colors.grey.withOpacity(1),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Radio(
                              activeColor: Colors.blue,
                              groupValue:
                                  authService.usuario.cesta.efectivo ? 2 : 1,
                              onChanged: tarjetasService.listaTarjetas.isEmpty
                                  ? null
                                  : (value) {
                                      authService.cambiarMetodoDePago(
                                          tipo: int.parse(value.toString()));
                                    },
                              value: 1,
                            )
                          ],
                        ),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AgregarNuevoMetodo()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: const Center(
                                      child: Icon(
                                        Icons.credit_card,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text('Agregar tarjeta',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 17,
                                        color: Colors.black.withOpacity(.8),
                                      ))
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(right: 13),
                                  child: const Icon(Icons.add))
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 65,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(137, 226, 137, 1)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 27),
                            child: Text(
                              '\$',
                              style: GoogleFonts.quicksand(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Efectivo',
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: Colors.black.withOpacity(.8),
                              ))
                        ],
                      ),
                      Radio(
                        activeColor: Colors.blue,
                        groupValue: authService.usuario.cesta.efectivo
                            ? 2
                            : tarjetasService.listaTarjetas.isEmpty
                                ? 2
                                : 0,
                        onChanged: (value) {
                          authService.cambiarMetodoDePago(
                              tipo: int.parse(value.toString()));
                        },
                        value: 2,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                /*Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.withOpacity(.1), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.wallet_giftcard,
                              color: Colors.black.withOpacity(.1),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('\$ 0.00',
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: Colors.black.withOpacity(.2),
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.black.withOpacity(.1), width: 1)),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(.1)),
                        ),
                      )
                    ],
                  ),
                ),*/
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Codigo promocional',
                style:
                    GoogleFonts.quicksand(color: Colors.black.withOpacity(.8)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 130,
                  child: TextFormField(
                    controller: controller,
                    onFieldSubmitted: (d) async {
                      if (authService.usuario.cesta.productos.isEmpty) {
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                          content: Text(
                            'Cesta vacia, descuento incalculable',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                            ),
                          ),
                        );
                        controller.text = '';
                        await Future.delayed(const Duration(milliseconds: 300));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        mostrarCarga(context);
                        var codigo = await authService.aplicarCupon(codigo: d);
                        controller.text = '';
                        Navigator.pop(context);
                        if (codigo.ok == false) {
                          final snackBar = SnackBar(
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                            content: Text(
                              codigo.msg,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                              ),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final nombre = codigo.usuario.split(' ');
                          final snackBar = SnackBar(
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                            content: Text(
                              '${nombre[0]} invita el envio ',
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          await Future.delayed(
                              const Duration(milliseconds: 600));
                          scrollListView(controller: widget.controller);
                        }
                      }
                    },
                    style: GoogleFonts.quicksand(color: Colors.blue),
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [LengthLimitingTextInputFormatter(9)],
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(bottom: 25, left: 15),
                      hintStyle: GoogleFonts.quicksand(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(.05), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(.05), width: 1)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (authService.usuario.cesta.productos.isEmpty) {
                      final snackBar = SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                        content: Text(
                          'Cesta vacia, descuento incalculable',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                          ),
                        ),
                      );
                      controller.text = '';
                      await Future.delayed(const Duration(milliseconds: 300));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      mostrarCarga(context);
                      var codigo = await authService.aplicarCupon(
                          codigo: controller.text);
                      controller.text = '';
                      Navigator.pop(context);
                      if (codigo.ok == false) {
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                          content: Text(
                            codigo.msg,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                            ),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final nombre = codigo.usuario.split(' ');
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                          content: Text(
                            '${nombre[0]} invita el envio ',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        await Future.delayed(const Duration(milliseconds: 600));
                        scrollListView(controller: widget.controller);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(.1)),
                    height: 50,
                    child: Center(
                      child: Text(
                        'Aplicar',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.black.withOpacity(.02),
          ),
          const SizedBox(height: 20),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            child: authService.calcularTiendas() > 1
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: RichText(
                          text: TextSpan(
                              style: GoogleFonts.quicksand(color: Colors.grey),
                              children: [
                            const TextSpan(
                                text:
                                    'Envio y cuota de servicio aumentado en modo multi-envio en la misma compra ( '),
                            TextSpan(
                                style: GoogleFonts.quicksand(
                                    color: Colors.black.withOpacity(.8),
                                    fontWeight: FontWeight.bold),
                                text: authService
                                    .calcularTiendasNombres()
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .replaceAll('(', '')
                                    .replaceAll(')', '')),
                            TextSpan(
                                text: ' ).',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black.withOpacity(.8))),
                            TextSpan(
                                text:
                                    ' Mas informaciona acerca de multi-envios.',
                                style: GoogleFonts.quicksand(
                                    color: Colors.blue.withOpacity(.8))),
                          ])),
                    ),
                  )
                : Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total orden',
                style: GoogleFonts.quicksand(),
              ),
              Text(
                '\$ ${authService.calcularTotal().toStringAsFixed(2)}',
                style: GoogleFonts.quicksand(fontSize: 18),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Envio',
                style: GoogleFonts.quicksand(),
              ),
              Row(
                children: [
                  authService.calcularTiendas() > 1
                      ? Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: const Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                        )
                      : Container(),
                  Text(
                    '\$ ${authService.calcularTotal() > 0 ? (18 * authService.calcularTiendas()).toStringAsFixed(2) : '0.00'}',
                    style: GoogleFonts.quicksand(fontSize: 18),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Servicio',
                style: GoogleFonts.quicksand(),
              ),
              Row(
                children: [
                  authService.calcularTiendas() > 1
                      ? Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: const Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                        )
                      : Container(),
                  Text(
                    '\$ ${authService.calcularTotal() > 0 ? ((11 * authService.calcularTiendas()) + (authService.calcularTiendas() > 1 ? 4 * authService.calcularTiendas() : 0)).toStringAsFixed(2) : '0.00'}',
                    style: GoogleFonts.quicksand(fontSize: 18),
                  ),
                ],
              )
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: authService.usuario.cesta.codigo != ''
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${nombre[0]} invita el envio',
                            style: GoogleFonts.quicksand(),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  authService.eliminarCupon();
                                },
                                child: Text(
                                  'Eliminar',
                                  style:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '- \$ ${authService.calcularTotal() > 0 ? (18 * authService.calcularTiendas()).toStringAsFixed(2) : '0.00'}',
                                style: GoogleFonts.quicksand(
                                    fontSize: 18, color: Colors.blue),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                : Container(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuenta total',
                style: GoogleFonts.quicksand(),
              ),
              Text(
                '\$ ${authService.calcularTotal() == 0 ? "0.00" : ((authService.calcularTiendas() > 1 ? 4 * authService.calcularTiendas() : 0) + -(authService.usuario.cesta.codigo != '' ? 18 * authService.calcularTiendas() : 0) + authService.calcularTotal() + (11 * authService.calcularTiendas()) + (18 * authService.calcularTiendas())).toStringAsFixed(2)}',
                style: GoogleFonts.quicksand(fontSize: 18),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: revisarTiendasAbiertas(
                              authSerice: authService,
                              pantallasService: pantallaService) ==
                          false
                      ? authService.usuario.cesta.productos.isEmpty ||
                              direccionesService.direcciones.isEmpty
                          ? null
                          : () async {
                              calculandoAlerta(context);
                              /*NotificationApi.showNotification(
                              title: 'Titulos',
                              body: 'Body',
                              payload: 'sarah.abs');*/
                              /*socketService.emit('mensaje-personal', {
                            'direccion': direccionesService.direcciones[
                                authService.usuario.cesta.direccion.titulo != ''
                                    ? direccionesService.direcciones.indexWhere(
                                        (element) =>
                                            authService.usuario.cesta.direccion
                                                .titulo ==
                                            element.titulo)
                                    : obtenerFavorito(direccionesService
                                                .direcciones) !=
                                            -1
                                        ? obtenerFavorito(
                                            direccionesService.direcciones)
                                        : 0],
                            'tarjeta': busqueda2 != -1
                                ? tarjetasService.listaTarjetas[busqueda2].id
                                : tarjetasService
                                    .listaTarjetas[
                                        busqueda != -1 ? busqueda : 0]
                                    .id,
                            'customer_id': authService.usuario.customerID,
                            'efectivo': authService.usuario.cesta.efectivo,
                            'prodcutos': authService.usuario.cesta.productos
                          });*/
                              final busqueda = tarjetasService.listaTarjetas
                                  .indexWhere((element) =>
                                      element.id ==
                                      customerService.tarjetaPredeterminada);
                              final busqueda2 = tarjetasService.listaTarjetas
                                  .indexWhere((element) =>
                                      element.id ==
                                      authService.usuario.cesta.tarjeta);
                              final venta = await authService.crearPedido(
                                  direccion: direccionesService.direcciones[authService
                                              .usuario.cesta.direccion.titulo !=
                                          ''
                                      ? direccionesService.direcciones
                                          .indexWhere((element) =>
                                              authService.usuario.cesta
                                                  .direccion.titulo ==
                                              element.titulo)
                                      : obtenerFavorito(direccionesService.direcciones) !=
                                              -1
                                          ? obtenerFavorito(
                                              direccionesService.direcciones)
                                          : 0],
                                  tarjeta: busqueda2 != -1
                                      ? tarjetasService
                                          .listaTarjetas[busqueda2].id
                                      : tarjetasService.listaTarjetas.isNotEmpty
                                          ? tarjetasService
                                              .listaTarjetas[
                                                  busqueda != -1 ? busqueda : 0]
                                              .id
                                          : '',
                                  customer: customerService.customer);

                              if (venta != null) {
                                pedidosService.agregarCompra(venta: venta);
                                // socketService.socket
                                //     .emit('enviar-pedido', venta);
                                scrollListView2(controller: widget.controller);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DoneView(
                                            venta: venta,
                                          )),
                                );
                              } else {
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 2),
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0, 0, 1),
                                  content: Text(
                                    'Error desconocido',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                    ),
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                      : null,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: revisarTiendasAbiertas(
                                authSerice: authService,
                                pantallasService: pantallaService) ==
                            false
                        ? authService.usuario.cesta.productos.isEmpty ||
                                direccionesService.direcciones.isEmpty
                            ? .1
                            : 1
                        : .1,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Center(
                          child: Text(
                            'Ordenar',
                            style: GoogleFonts.quicksand(
                                color: Colors.black, fontSize: 20),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool revisarTiendasAbiertas(
      {required AuthService authSerice,
      required LlenarPantallasService pantallasService}) {
    bool isClosed = false;

    for (var element2 in authSerice.usuario.cesta.productos) {
      Tienda tienda = pantallasService.tiendas
          .firstWhere((element) => element.nombre == element2.tienda);

      if (tienda.online == false) {
        isClosed = true;
      }
    }

    return isClosed;
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }

  scrollListView({required ScrollController controller}) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  scrollListView2({required ScrollController controller}) {
    controller.animateTo(
      controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }

  metodoPredeterminado(BuildContext context) async {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        backgroundColor: Colors.white,
        elevation: 0,
        builder: (builder) {
          return const MetodoPredeterminado();
        });
  }
}
