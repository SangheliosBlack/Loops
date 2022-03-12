import 'package:delivery/global/styles.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/direcciones.service.dart';
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
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: Styles.letterCustom(18, true),
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
                        style:
                            GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                      ))
                  : Container()
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.7),
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              'Enviado por : ',
                              style: GoogleFonts.quicksand(
                                  fontSize: 10,
                                  color: Colors.grey.withOpacity(.7)),
                            ),
                            Text(
                              'Nombre negocio',
                              style: GoogleFonts.quicksand(
                                  fontSize: 10, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio unitario : ',
                              style: GoogleFonts.quicksand(
                                  fontSize: 10,
                                  color: Colors.grey.withOpacity(.7)),
                            ),
                            Text('\$45.00',
                                style: Styles.letterCustom(25, false, .7)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: const Color(0xffF3F5F6)
                                        .withOpacity(.5)),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.grey.withOpacity(.7),
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '1',
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600),
                                )),
                            Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color:
                                        const Color.fromRGBO(234, 248, 248, 1)),
                                child: const Icon(
                                  Icons.add,
                                  color: Color.fromRGBO(62, 204, 191, 1),
                                )),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
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

    return direccionesService.direcciones.isNotEmpty
        ? DireccionBuildWidget(
            predeterminado: direccionesService
                .direcciones[direccionesService.direccionPredeterminada]
                .predeterminado,
            icono: direccionesService
                .direcciones[direccionesService.direccionPredeterminada].icono,
            uid: direccionesService
                .direcciones[direccionesService.direccionPredeterminada].id,
            index: direccionesService.direccionPredeterminada,
            titulo: direccionesService
                .direcciones[direccionesService.direccionPredeterminada].texto,
            descripcion: direccionesService
                .direcciones[direccionesService.direccionPredeterminada]
                .descripcion,
            latitud: direccionesService
                .direcciones[direccionesService.direccionPredeterminada]
                .coordenadas
                .latitud,
            longitud: direccionesService
                .direcciones[direccionesService.direccionPredeterminada]
                .coordenadas
                .longitud,
            onlyShow: true,
          )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              try {
                final resultado = await showSearch(
                    context: context, delegate: SearchDestination());
                retornoBusqueda(resultado!, direccionesService, context, true);
              } catch (e) {
                debugPrint('Ningun lugar seleccionado');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Agregar nueva direccion',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  const Icon(
                    Icons.add,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          );
  }

  void retornoBusqueda(
      SearchResult result,
      DireccionesService direccionesService,
      BuildContext context,
      bool predeterminado) async {
    calculandoAlerta(context);
    await Future.delayed(const Duration(milliseconds: 1500));

    final String texto = result.nombreDestino;
    final String descripcion = result.descripcion;
    final latitud = result.position.latitude;
    final longitud = result.position.longitude;

    final nuevaDireccion = await direccionesService.agregarNuevaDireccion(
        texto, descripcion, latitud, longitud, predeterminado);
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
      padding: const EdgeInsets.all(15),
      decoration: Styles.containerCustom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Metodo de pago',
                style: Styles.letterCustom(14),
              ),
              tarjetasService.listaTarjetas.length > 1
                  ? GestureDetector(
                      onTap: () {
                        metodoPredeterminado(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromRGBO(234, 248, 248, 1),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              'Cambiar tarjeta',
                              style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: const Color.fromRGBO(62, 204, 191, 1)),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.style,
                              color: Color.fromRGBO(62, 204, 191, 1),
                            ),
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
                        color: Colors.grey.withOpacity(.1), width: 1),
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
                                  fontWeight: FontWeight.w600))
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
                        color: Colors.grey.withOpacity(.1), width: 1),
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
                              color: Color.fromRGBO(2, 204, 66, .7),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text('Efectivo',
                              style: GoogleFonts.quicksand(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(.8),
                                  fontWeight: FontWeight.w600))
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
                ),
                const SizedBox(height: 5),
                Container(
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
                              Icons.account_balance_wallet,
                              color: Colors.black.withOpacity(.2),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('\$ 0.00',
                              style: GoogleFonts.quicksand(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(.2),
                                  fontWeight: FontWeight.w600))
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Codigo promocional',
                style: Styles.letterCustom(14),
              ),
              Text('VF85SD', style: Styles.letterCustom(14, true, .8))
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
                    style: GoogleFonts.quicksand(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(bottom: 10, left: 10),
                      hintText: 'CODIGO CUPON',
                      hintStyle: Styles.letterCustom(12, false, .3),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(.1), width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(.1), width: 2)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: const Color.fromRGBO(255, 240, 235, 1)),
                    onPressed: () {},
                    child: Text(
                      'Aplicar',
                      style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: const Color.fromRGBO(255, 103, 50, 1)),
                    ))
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.black.withOpacity(.05),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total orden',
                style: Styles.letterCustom(14),
              ),
              Text('\$ 150.00', style: Styles.letterCustom(14, true, .8))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Envio',
                style: Styles.letterCustom(14),
              ),
              Text('\$ 50.00', style: Styles.letterCustom(14, true, .8))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuenta total',
                style: Styles.letterCustom(14),
              ),
              Text('\$ 200.00', style: Styles.letterCustom(14, true, .8))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0))),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.moped),
                              const SizedBox(width: 10),
                              Text(
                                'Ordenar',
                                style: Styles.letterCustom(17, true, -0.1),
                              ),
                            ],
                          ))),
                ),
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
        enableDrag: true,
        backgroundColor: Colors.white,
        elevation: 0,
        builder: (builder) {
          return const MetodoPredeterminado();
        });
  }
}
