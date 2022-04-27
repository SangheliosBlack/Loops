import 'package:delivery/global/styles.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/stripe_service.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:delivery/views/extras/direcciones_seleccion.dart';
import 'package:delivery/views/extras/metodo_predeterminado.dart';
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
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              item(context, authService.usuario.cesta.productos[index], index),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 0),
          itemCount: authService.usuario.cesta.productos.length),
    );
  }

  Widget item(BuildContext context, Producto producto, int index) {
    final authService = Provider.of<AuthService>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerProductoView(producto: producto)),
        );
      },
      child: Container(
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
              height: 80,
              width: 80,
              child: Hero(
                tag: producto.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: const Image(
                    image: NetworkImage(
                        'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          maxLines: 2,
                          style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      elecciones(producto: producto),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                          color: Colors.grey, fontSize: 13),
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
                            Text(producto.precio.toStringAsFixed(2),
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
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 13),
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 33),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(.1))),
                    child: Text(
                      'Eliminar',
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.8)),
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
                          await authService.eliminarProductoCesta(pos: index);
                          Navigator.pop(context);
                        } else {
                          authService.actulizarCantidad(
                              cantidad: (producto.cantidad - 1).toInt(),
                              index: index);
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: producto.cantidad == 1
                                  ? Colors.red.withOpacity(.05)
                                  : const Color(0xffF3F5F6).withOpacity(.5)),
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
                        width: 43,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            producto.cantidad.toString(),
                            style: GoogleFonts.quicksand(fontSize: 20),
                          ),
                        )),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (producto.cantidad < 15) {
                          authService.actulizarCantidad(
                              cantidad: (producto.cantidad + 1).toInt(),
                              index: index);
                        }
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
    );
  }

  String elecciones({required Producto producto}) {
    String valor = '';

    try {
      for (var element in producto.opciones[0].listado) {
        if (element.activo) {
          valor = valor + element.tipo;
        }
      }
      // ignore: empty_catches
    } catch (e) {}

    try {
      for (var element in producto.opciones[1].listado) {
        if (element.activo) {
          valor = valor + '  |  ' + element.tipo;
        }
      }
      // ignore: empty_catches
    } catch (e) {}

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
              ? authService.usuario.cesta.direccion
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

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tarjetasService = Provider.of<TarjetasService>(context);
    final customerService = Provider.of<StripeService>(context);
    final authService = Provider.of<AuthService>(context, listen: true);

    final busqueda = tarjetasService.listaTarjetas.indexWhere(
        (element) => element.id == customerService.tarjetaPredeterminada);
    final busqueda2 = tarjetasService.listaTarjetas.indexWhere(
        (element) => element.id == authService.usuario.cesta.tarjeta);

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
                  : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        navigationService.navegarDraw(
                            ruta: '/drawer/metodosPago');
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
                                      SizedBox(
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
                                          height: 45,
                                          width: 45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        busqueda2 != -1
                                            ? (tarjetasService
                                                    .listaTarjetas[busqueda2]
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
                                          color: Colors.black.withOpacity(1),
                                        )),
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
                                              color:
                                                  Colors.grey.withOpacity(.7),
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
                              onChanged: (value) {
                                authService.cambiarMetodoDePago(
                                    tipo: int.parse(value.toString()));
                              },
                              value: 1,
                            )
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.credit_card),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text('Agregar tarjeta',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(.8),
                                    ))
                              ],
                            ),
                            const Icon(Icons.add)
                          ],
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
                        groupValue: authService.usuario.cesta.efectivo ? 2 : 0,
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
          /*Row(
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
                    style: GoogleFonts.quicksand(color: Colors.blue),
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [LengthLimitingTextInputFormatter(7)],
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
                Container(
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
                )
              ],
            ),
          ),*/
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.black.withOpacity(.02),
          ),
          const SizedBox(height: 20),
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
              Text(
                '\$ ${authService.calcularTotal() > 0 ? '19.00' : '0.00'}',
                style: GoogleFonts.quicksand(fontSize: 18),
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
              Text(
                '\$ ${authService.calcularTotal() > 0 ? '12.00' : '0.00'}',
                style: GoogleFonts.quicksand(fontSize: 18),
              )
            ],
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
                '\$ ${(authService.calcularTotal() + 12 + 19).toStringAsFixed(2)}',
                style: GoogleFonts.quicksand(fontSize: 18),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.moped,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Ordenar',
                          style: GoogleFonts.quicksand(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
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
