import 'package:delivery/global/styles.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/stripe_service.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:delivery/views/extras/metodo_predeterminado.dart';
import 'package:delivery/widgets/direcciones_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Cambiar',
                          style: GoogleFonts.quicksand(color: Colors.grey),
                        ))
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
}

class OrderItems extends StatelessWidget {
  const OrderItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => item(context),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 0),
        itemCount: 3);
  }

  Widget item(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(233, 78, 78, 1),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              'Eliminar',
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
          ],
        ),
      ),
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
            Column(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: const Image(
                      image: NetworkImage(
                          'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
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
                          'Nombre del producto',
                          maxLines: 2,
                          style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Lugar de donde pide',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                              color: Colors.grey, fontSize: 13),
                        )
                      ],
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
                            Text('45.00',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffF3F5F6).withOpacity(.5)),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                      color: Colors.grey.withOpacity(.7),
                    )),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '1',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                    )),
                Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(234, 248, 248, 1)),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: Color.fromRGBO(62, 204, 191, 1),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryOptionsContainer extends StatelessWidget {
  const DeliveryOptionsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    final sugerencia = Provider.of<PermissionStatusProvider>(context);

    return direccionesService.direcciones.isNotEmpty
        ? direccionFavorita(direccionesService)
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
      DireccionesService direccionesService) {
    return DireccionBuildWidget(
      onlyShow: true,
      direccion: direccionesService.direcciones[
          obtenerFavorito(direccionesService.direcciones) != -1
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

    final busqueda = tarjetasService.listaTarjetas.indexWhere(
        (element) => element.id == customerService.tarjetaPredeterminada);

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
                style: GoogleFonts.quicksand(color: Colors.grey),
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
                                  fontSize: 14, color: Colors.black),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.style_outlined,
                                color: Colors.black),
                            const SizedBox(width: 2),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.withOpacity(.05), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 55,
                            child: SvgPicture.asset(
                              tarjetasService
                                          .listaTarjetas[busqueda].card.brand ==
                                      'visa'
                                  ? 'assets/images/visa_color.svg'
                                  : 'assets/images/mc.svg',
                              height: 35,
                              width: 35,
                            ),
                          ),
                          Text(
                              tarjetasService
                                  .listaTarjetas[busqueda].card.last4,
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: Colors.black.withOpacity(1),
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 1)),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.withOpacity(.05), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.attach_money,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text('Efectivo',
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: Colors.black.withOpacity(.8),
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.black.withOpacity(.05),
                                width: 1)),
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
                style: GoogleFonts.quicksand(color: Colors.grey),
              ),
              Text('VF85SD', style: GoogleFonts.quicksand(color: Colors.blue))
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 40,
                  width: 180,
                  child: TextFormField(
                    style:
                        GoogleFonts.quicksand(color: Colors.grey, fontSize: 12),
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(bottom: 10, left: 10),
                      hintStyle: GoogleFonts.quicksand(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(.05), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(.05), width: 1)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: Colors.grey.withOpacity(.1)),
                    onPressed: () {},
                    child: Text(
                      'Aplicar',
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.grey),
                    ))
              ],
            ),
          ),
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
                '\$ 150.00',
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
                '\$ 50.00',
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
                '\$ 200.00',
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
                        borderRadius: BorderRadius.circular(20),
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
