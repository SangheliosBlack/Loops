import 'dart:ui';

import 'package:delivery/global/styles.dart';
import 'package:delivery/models/lista_separada.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/categoria_view.dart';
import 'package:delivery/views/ver_todo.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomButtonCategory extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const CustomButtonCategory(
      {Key? key, required this.titulo, required this.icono})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            margin: const EdgeInsets.only(top: 20.0, bottom: 5.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icono,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
              constraints: const BoxConstraints(maxWidth: 60),
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(
                titulo,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(color: Colors.grey),
              ))
        ],
      ),
    );
  }
}

class CustomMsgTo extends StatelessWidget {
  final String titulo;

  const CustomMsgTo({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(titulo, style: Styles.letterCustom(20)),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: Styles.containerCustom(),
            child: Text(
              "Ver todo",
              style: GoogleFonts.quicksand(
                  color: Theme.of(context).primaryColor, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}

class OffertsCard extends StatelessWidget {
  const OffertsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.containerCustom(),
      padding: const EdgeInsets.all(10),
      width: 230,
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Image(
                image: NetworkImage(
                    "https://www.hola.com/imagenes/cocina/noticiaslibros/20210528190392/las-mejores-hamburguesas-de-espana/0-957-500/portada-nyb-m.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              bottom: 15.0,
              left: 15.0,
              child: Container(
                width: 200,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nombre producto",
                          style: Styles.letterCustom(14, true, .7),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2.0, bottom: 5),
                          child: Text("Pequeña descripcion",
                              style: Styles.letterCustom(11, false, 0.4)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "\$50.00",
                                  style:
                                      Styles.letterCustom(12, true, .3, true),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "\$45.00",
                                  style: Styles.letterCustom(15, true, .8),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                'Agregar',
                                style: Styles.letterCustom(13, false, -0.1),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class OffertsCard2 extends StatelessWidget {
  const OffertsCard2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.containerCustom(),
      padding: const EdgeInsets.all(10),
      width: 230,
      child: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
          ),
          Positioned(
              bottom: 15.0,
              left: 15.0,
              child: Container(
                width: 200,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                '',
                                style: Styles.letterCustom(13, false, -0.1),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
              height: 300,
              decoration: const BoxDecoration(color: Colors.red),
              width: 250,
              child: const SizedBox(
                height: double.infinity,
                child: Image(
                  image: NetworkImage(
                      'https://traveler.marriott.com/es/wp-content/uploads/sites/2/2019/10/Maverick_interior.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 15.0,
                      sigmaY: 15.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Nombre del establcimiento  ',
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10))),
                  child: Center(
                      child: Text(
                    '4.8',
                    style: GoogleFonts.quicksand(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
                ))
          ],
        ),
      ),
    );
  }
}

class ListadoCategorias extends StatelessWidget {
  const ListadoCategorias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final llenarPantalla = Provider.of<LlenarPantallasService>(context);
    return Container(
        margin: const EdgeInsets.only(top: 15),
        height: 40,
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 3000),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              itemBuilder: (BuildContext context, int index) => itemCategory(
                context,
                llenarPantalla.categorias[index],
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                width: 10,
              ),
              itemCount: llenarPantalla.categorias.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
            )));
  }

  Widget itemCategory(BuildContext context, String titulo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoriaView(
                    titulo: titulo,
                  )),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(249, 250, 252, 1),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              titulo,
              style: GoogleFonts.quicksand(color: Colors.black.withOpacity(.8)),
            )
          ],
        ),
      ),
    );
  }
}

Widget itemCategoryVoid(BuildContext context, String titulo, IconData icono) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(15)),
    padding: const EdgeInsets.all(8),
  );
}

class ListaProductos extends StatelessWidget {
  const ListaProductos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(viewportFraction: 1, initialPage: 0);
    final llenarPantallasService = Provider.of<LlenarPantallasService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: Styles.containerCustom(),
                  child: Row(
                    children: [
                      Text(
                        'Productos',
                        style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.7),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      side: const BorderSide(width: 1, color: Colors.white),
                      primary: Colors.white,
                      backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerTodoView(
                                titulo: 'Productos',
                              )),
                    );
                  },
                  child: Text(
                    'Ver todo',
                    style: GoogleFonts.quicksand(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.only(bottom: 8),
            child: llenarPantallasService.productos.isNotEmpty
                ? SmoothPageIndicator(
                    controller: controller,
                    count: llenarPantallasService.productos.isNotEmpty
                        ? llenarPantallasService.productos.length
                        : 1,
                    textDirection: TextDirection.ltr,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.black.withOpacity(.8),
                      dotColor: Colors.black.withOpacity(.2),
                    ),
                  )
                : Container()),
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 5),
          height: 305,
          child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller,
              itemCount: llenarPantallasService.productos.length,
              itemBuilder: (BuildContext context, int index) {
                return item2(lista: llenarPantallasService.productos[index]);
              }),
        ),
      ],
    );
  }

  Widget item2({required Separado lista}) {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            ProductoGeneral(producto: lista.productos[index]),
        itemCount: lista.productos.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 0,
        ),
      ),
    );
  }
}
