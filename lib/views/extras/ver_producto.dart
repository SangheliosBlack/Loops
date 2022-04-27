import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/views/notificaciones_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerProductoView extends StatefulWidget {
  const VerProductoView({
    Key? key,
    required this.producto,
  }) : super(key: key);

  final Producto producto;

  @override
  State<VerProductoView> createState() => _VerProductoViewState();
}

class _VerProductoViewState extends State<VerProductoView> {
  String valor1 = '';
  String valor2 = '';
  int cantidad = 1;

  num eleccion1 = 0;
  num eleccion2 = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 75,
            centerTitle: true,
            actions: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificacionesView()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: 45,
                        height: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 0,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: authService.totalPiezas() == 0 ? 0 : 1,
                            child: Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color.fromRGBO(62, 204, 191, 1),
                              ),
                              child: Center(
                                child: Text(
                                  authService.totalPiezas().toString(),
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
            leadingWidth: 350,
            leading: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total pedido:',
                          style: GoogleFonts.quicksand(color: Colors.grey)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$',
                            style: GoogleFonts.playfairDisplay(
                                color: Colors.black, fontSize: 20),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            authService.calcularTotal().toStringAsFixed(2),
                            style: GoogleFonts.quicksand(
                              color: const Color.fromRGBO(47, 47, 47, .9),
                              fontSize: 30,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            backgroundColor: Colors.white,
            elevation: 0),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: width - 30,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Hero(
                tag: widget.producto.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: const Image(
                      image: NetworkImage(
                          'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(widget.producto.tienda,
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.grey)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '4.9',
                        style: GoogleFonts.playfairDisplay(
                            color: const Color.fromRGBO(62, 204, 191, 1),
                            height: .8,
                            fontSize: 30),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(widget.producto.nombre,
                          style: GoogleFonts.quicksand(
                              fontSize: 25,
                              color: const Color.fromRGBO(83, 84, 85, 1))),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500,',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.quicksand(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            widget.producto.opciones.isEmpty
                ? Container()
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final Opcion opcion = widget.producto.opciones[index];
                      return Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(opcion.titulo,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  Text(index == 0 ? valor1 : valor2,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 14, color: Colors.grey)),
                                ],
                              )),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SizedBox(
                                height: 45,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(right: 25),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index2) {
                                    final opcionIndex = opcion.listado[index2];
                                    return GestureDetector(
                                      onTap: (() {
                                        if (mounted) {
                                          setState(() {
                                            if (index == 0) {
                                              eleccion1 = index2;
                                              valor1 = opcionIndex.tipo;
                                            } else {
                                              eleccion2 = index2;
                                              valor2 = opcionIndex.tipo;
                                            }
                                          });
                                        }
                                      }),
                                      child: AnimatedContainer(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 25),
                                          decoration: index == 0
                                              ? BoxDecoration(
                                                  color: opcionIndex.tipo ==
                                                          valor1
                                                      ? const Color.fromRGBO(
                                                          62, 204, 191, 1)
                                                      : const Color.fromRGBO(
                                                          200, 201, 203, .2),
                                                  borderRadius:
                                                      BorderRadius.circular(25))
                                              : BoxDecoration(
                                                  color: opcionIndex.tipo ==
                                                          valor2
                                                      ? const Color.fromRGBO(
                                                          62, 204, 191, 1)
                                                      : const Color.fromRGBO(
                                                          200, 201, 203, .2),
                                                  borderRadius:
                                                      BorderRadius.circular(25)),
                                          duration: const Duration(milliseconds: 100),
                                          child: Center(
                                              child: Text(opcionIndex.tipo,
                                                  style: index == 0
                                                      ? GoogleFonts.quicksand(
                                                          color: opcionIndex
                                                                      .tipo ==
                                                                  valor1
                                                              ? Colors.white
                                                              : Colors.grey,
                                                        )
                                                      : GoogleFonts.quicksand(
                                                          color: opcionIndex
                                                                      .tipo ==
                                                                  valor2
                                                              ? Colors.white
                                                              : Colors.grey,
                                                        )))),
                                    );
                                  },
                                  itemCount: opcion.listado.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(
                                    width: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: widget.producto.opciones.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 15,
                    ),
                  ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: cantidad > 1
                        ? () {
                            if (mounted) {
                              setState(() {
                                cantidad--;
                              });
                            }
                          }
                        : null,
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: cantidad == 0
                            ? Border.all(
                                width: 1, color: Colors.red.withOpacity(.8))
                            : Border.all(
                                width: 1,
                                color: Colors.grey
                                    .withOpacity(cantidad > 1 ? .2 : .1)),
                      ),
                      duration: const Duration(milliseconds: 500),
                      child: Icon(
                        Icons.remove,
                        color: cantidad == 0
                            ? Colors.red.withOpacity(.8)
                            : Colors.grey.withOpacity(cantidad > 1 ? 1 : .4),
                      ),
                    ),
                  ),
                  Container(
                      width: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(cantidad.toString(),
                            style: GoogleFonts.quicksand(
                                color: Colors.black.withOpacity(.8),
                                fontSize: 30)),
                      )),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (cantidad < 15) {
                        if (mounted) {
                          setState(() {
                            cantidad++;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(.2)),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Total :',
                          style: GoogleFonts.quicksand(color: Colors.grey)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$',
                              style: GoogleFonts.playfairDisplay(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(65, 65, 66, 1),
                                fontSize: 21,
                              )),
                          const SizedBox(width: 3),
                          Text(
                              (widget.producto.precio * cantidad)
                                  .toStringAsFixed(2),
                              style: GoogleFonts.quicksand(
                                color: const Color.fromRGBO(65, 65, 66, 1),
                                fontSize: 33,
                              )),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.producto.opciones.length == 1
                          ? valor1.isNotEmpty
                              ? () async {
                                  calculandoAlerta(context);
                                  await authService.agregarProductoCesta(
                                      producto: widget.producto,
                                      cantidad: cantidad,
                                      eleccion1: valor1,
                                      eleccion2: valor2);

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              : null
                          : valor1.isNotEmpty && valor2.isNotEmpty
                              ? () async {
                                  calculandoAlerta(context);
                                  await authService.agregarProductoCesta(
                                      producto: widget.producto,
                                      cantidad: cantidad,
                                      eleccion1: valor1,
                                      eleccion2: valor2);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              : null,
                      child: AnimatedSize(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: cantidad == 0
                                    ? Border.all(
                                        width: 1,
                                        color: Colors.red.withOpacity(.8))
                                    : Border.all(
                                        width: 1,
                                        color: Colors.black.withOpacity(
                                            widget.producto.opciones.length == 1
                                                ? valor1.isNotEmpty
                                                    ? .8
                                                    : .1
                                                : valor1.isNotEmpty &&
                                                        valor2.isNotEmpty
                                                    ? .8
                                                    : .1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.moped_sharp,
                                  color: cantidad == 0
                                      ? Colors.red.withOpacity(.8)
                                      : Colors.black.withOpacity(
                                          widget.producto.opciones.length == 1
                                              ? valor1.isNotEmpty
                                                  ? .8
                                                  : .1
                                              : valor1.isNotEmpty &&
                                                      valor2.isNotEmpty
                                                  ? .8
                                                  : .1),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  'Agregar',
                                  style: GoogleFonts.quicksand(
                                      color: cantidad == 0
                                          ? Colors.red.withOpacity(.8)
                                          : Colors.black.withOpacity(
                                              widget.producto.opciones.length ==
                                                      1
                                                  ? valor1.isNotEmpty
                                                      ? .8
                                                      : .1
                                                  : valor1.isNotEmpty &&
                                                          valor2.isNotEmpty
                                                      ? .8
                                                      : .1),
                                      fontSize: 20),
                                )
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  mostarCambio() {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      content: Text(
        'Pedido modificado',
        style: GoogleFonts.quicksand(
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
