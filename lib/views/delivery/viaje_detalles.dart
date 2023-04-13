import 'package:delivery/models/venta_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ViajesDetallesView extends StatelessWidget {
  final int index;
  final PedidoProducto envio;
  const ViajesDetallesView({Key? key, required this.envio, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String formattedDate =
        DateFormat.yMEd('es-MX').add_jm().format(envio.createdAt.toLocal());
    final nombre = envio.usuario.nombre.split(' ');
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        toolbarHeight: 250,
        title: Stack(
          children: [
            Container(
              height: 300,
              width: width,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: envio.id,
                    child: envio.entregadoCliente
                        ? const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 60,
                          )
                        : const Icon(
                            Icons.pending,
                            color: Colors.white,
                            size: 60,
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    envio.entregadoCliente ? 'Completado' : 'Incompleto',
                    style: GoogleFonts.quicksand(
                        fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.quicksand(
                        fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Orden No. # ${index + 1} - $formattedDate',
                    style: GoogleFonts.quicksand(
                        fontSize: 14, color: Colors.white.withOpacity(.4)),
                  )
                ],
              ),
            ),
            Positioned(
                top: 55,
                left: 10,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(1),
                        ))))
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text('Cliente detalles',
                        style: GoogleFonts.quicksand(
                            color: Colors.grey, fontSize: 15)),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const SizedBox(
                            width: 45,
                            height: 45,
                            child: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            '${nombre[0]} ${nombre.length - 2 > 0
                                    ? nombre[nombre.length - 2][0]
                                    : ''}',
                            style: GoogleFonts.quicksand(
                                color: Colors.black, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey.withOpacity(.2),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Envio',
                          style: GoogleFonts.quicksand(
                              color: Colors.grey, fontSize: 15)),
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          ListView.separated(
                            padding: const EdgeInsets.only(top: 15, left: 25),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, __) => Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(192, 195, 192, 1),
                                      shape: BoxShape.circle),
                                ),
                              ],
                            ),
                            itemCount: 13,
                            separatorBuilder: (_, __) => const SizedBox(
                              height: 15,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            child: SizedBox(
                              width: width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(1),
                                        ),
                                        child: const Icon(
                                          Icons.home,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Inicio',
                                            style: GoogleFonts.quicksand(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(.8)),
                                          ),
                                          Text(
                                            envio.tienda,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.quicksand(
                                                color: Colors.blue),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            width: width - 105,
                                            child: Text(
                                              envio.direccionNegocio.titulo,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.quicksand(
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  // ignore: prefer_const_constructors
                                  SizedBox(
                                    height: 80,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(1),
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fin',
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black
                                                    .withOpacity(.8)),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            width: width - 105,
                                            child: Text(
                                              envio.direccionCliente.titulo,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.quicksand(
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey.withOpacity(.2),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Articulos ordenados',
                        style: GoogleFonts.quicksand(
                            color: Colors.grey, fontSize: 15)),
                    const SizedBox(
                      height: 15,
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) => Row(
                        children: [
                          Text(
                            'x${envio.productos[index].cantidad}',
                            style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(1),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            envio.productos[index].nombre.toUpperCase(),
                            style: GoogleFonts.quicksand(fontSize: 14),
                          )
                        ],
                      ),
                      itemCount: envio.productos.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        width: 5,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey.withOpacity(.2),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      envio.entregadoCliente
                          ? 'Total depositado'
                          : 'Total en espera...',
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.8), fontSize: 15),
                    ),
                    Text(
                      '\$ 25.66',
                      style: GoogleFonts.quicksand(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(1),
                          fontSize: 55),
                    ),
                    const SizedBox(
                      height: 60,
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
