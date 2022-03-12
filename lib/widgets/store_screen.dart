import 'dart:ui';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/models/lista_separada.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/extras/categoria_view.dart';
import 'package:delivery/widgets/place_holder.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:delivery/widgets/store_individual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
              child: Shimmer(height: 200, width: 230, radius: 10)),
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
                        const Shimmer(height: 15, width: 150, radius: 10),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 5),
                          child:
                              const Shimmer(height: 10, width: 150, radius: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Shimmer(height: 15, width: 30, radius: 10),
                                SizedBox(width: 5),
                                Shimmer(height: 15, width: 40, radius: 10),
                              ],
                            ),
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

class ListCategory extends StatelessWidget {
  const ListCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final llenarPantalla = Provider.of<LlenarPantallasService>(context);
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        height: 40.0,
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 3000),
            child: llenarPantalla.categorias.isEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemBuilder: (BuildContext context, int index) =>
                        itemCategoryVoid(
                            context,
                            Statics.listaCategorias[index]['titulo'],
                            Statics.listaCategorias[index]['icono']),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 10,
                    ),
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemBuilder: (BuildContext context, int index) =>
                        itemCategory(
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
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(249, 250, 252, 1),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(200, 201, 203, 1)),
              child: const Icon(
                Icons.info,
                color: Colors.white,
                size: 17,
              ),
            ),
            Text(
              titulo,
              style: Styles.letterCustom(13, false, .5),
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
      child: const Shimmer(
        height: 50,
        width: 120,
        radius: 15,
      ));
}

class ListItemStore extends StatelessWidget {
  const ListItemStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final llenarPantallasService = Provider.of<LlenarPantallasService>(context);
    PageController controller = PageController(viewportFraction: 1);
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 5),
      height: 345,
      child: llenarPantallasService.productos.isEmpty
          ? PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) => item1())
          : PageView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller,
              itemCount: llenarPantallasService.productos.length,
              itemBuilder: (BuildContext context, int index) {
                return item2(lista: llenarPantallasService.productos[index]);
              }),
    );
  }

  Widget item1() {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25),
      child: Column(
        children: const [
          ItemGeneralW(),
          SizedBox(height: 10),
          ItemGeneralW(),
          SizedBox(height: 10),
          ItemGeneralW(),
        ],
      ),
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
          height: 10,
        ),
      ),
    );
  }
}

class ItemGeneralW extends StatelessWidget {
  const ItemGeneralW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showInfo(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: Styles.containerCustom(),
        child: Row(
          children: [
            Container(
              decoration: Styles.containerCustom(8),
              width: 90,
              height: 90,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const Shimmer(height: 90, width: 90, radius: 8)),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Shimmer(height: 15, width: 130, radius: 15),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.7),
                              shape: BoxShape.circle),
                          child: Text('0.0',
                              style: Styles.letterCustom(10, false, -1.0)),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          itemSize: 15,
                          ignoreGestures: true,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Shimmer(height: 15, width: 35, radius: 10),
                              SizedBox(width: 10),
                              Shimmer(height: 20, width: 55, radius: 10),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: Styles.containerCustom(),
                            child: const Shimmer(
                                height: 20, width: 50, radius: 15),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
