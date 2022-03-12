import 'package:delivery/global/styles.dart';
import 'package:delivery/models/productos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';


showInfo(BuildContext context) async => showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    builder: (builder) {
      return ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              Column(
                children: [headerPhoto(context), generalInfo()],
              ),
              Positioned(
                bottom: 65,
                right: 30,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.favorite),
                ),
              )
            ],
          ),
          detailContainer(context)
        ],
      );
    });

editarTituloProducto(BuildContext context) async => {
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return const Text('Jamon');
          })
    };

Container detailContainer2(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.',
                style: Styles.letterCustom(13, false),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(children: [
                  const Icon(Icons.schedule),
                  Text(
                    '30 min',
                    style: Styles.letterCustom(13, false),
                  ),
                  const SizedBox(width: 5)
                ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$50.00',
                        style: Styles.letterCustom(15, true, .3, true)),
                    const SizedBox(width: 5),
                    Text('\$45.00', style: Styles.letterCustom(19, true, .8))
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: Styles.containerCustom(),
                  child: Text('10% off',
                      style: Styles.letterCustom(15, true, 0.8)),
                ),
              ],
            )
          ],
        ),
        totalActions(),
        actionButtons(context),
      ],
    ),
  );
}

Container detailContainer(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.',
                style: Styles.letterCustom(13, false),
              ),
            ),
          ],
        ),
        totalActions(),
        actionButtons(context),
      ],
    ),
  );
}

Container totalActions() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.remove,
            size: 20,
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('1', style: Styles.letterCustom(20, true, 0.8))),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.add,
            size: 20,
          ),
        )
      ]),
      Row(
        children: [
          Text('Total : ', style: Styles.letterCustom(13, false, .3)),
          const SizedBox(width: 5),
          Text('\$45.00', style: Styles.letterCustom(25, true, 1)),
        ],
      )
    ]),
  );
}

Container actionButtons(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    width: 400,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          child: SizedBox(
              height: 45,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(54, 202, 188, 1)),
                  ),
                  child: const Icon(Icons.bolt))),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            child: SizedBox(
                height: 45,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Agregar',
                          style: Styles.letterCustom(20, true, -0.1),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.moped_sharp),
                      ],
                    ))),
          ),
        ),
      ],
    ),
  );
}

Container generalInfo() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text('Titulo', style: Styles.letterCustom(20, true, .8)),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(234, 248, 248, 1),
                  shape: BoxShape.circle),
              child: Text('3.6',
                  style: GoogleFonts.quicksand(
                      color: const Color.fromRGBO(40, 200, 184, 1),
                      fontSize: 14)),
            ),
            const SizedBox(width: 4),
            RatingBar.builder(
              initialRating: 3.5,
              itemSize: 17,
              ignoreGestures: true,
              minRating: 1,
              direction: Axis.horizontal,
              unratedColor: const Color.fromRGBO(234, 248, 248, 1),
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Color.fromRGBO(40, 200, 184, 1),
              ),
              onRatingUpdate: (rating) {},
            ),
            Text('(24)', style: Styles.letterCustom(12, false, .2))
          ],
        )
      ],
    ),
  );
}

Widget headerPhoto(BuildContext context) {
  return const ClipRRect(
    child: SizedBox(
      height: 220,
      width: double.infinity,
      child:  Image(
        image: NetworkImage(
            'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class HeaderStoreIndividual extends StatelessWidget {
  const HeaderStoreIndividual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg",
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg",
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg",
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg"
    ];

    return Container(
      margin: const EdgeInsets.only(top: 90),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(40, 40, 40, .3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: NetworkImage(
                        'https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre negocio',
                        style: GoogleFonts.quicksand(
                            fontSize: 30, color: Colors.black)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          decoration: Styles.containerCustom(),
                          child: Row(
                            children: [
                              Text('4.7', style: Styles.letterCustom(12, true)),
                              const SizedBox(width: 3),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text('(200+)',
                                  style: Styles.letterCustom(8, true)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: Styles.containerCustom(),
                            child: Icon(
                              FontAwesomeIcons.facebookF,
                              size: 15,
                              color: Theme.of(context).primaryColor,
                            )),
                        const SizedBox(width: 5),
                        Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: Styles.containerCustom(),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              size: 15,
                              color: Theme.of(context).primaryColor,
                            )),
                        const SizedBox(width: 5),
                        Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: Styles.containerCustom(),
                            child: Icon(
                              Icons.favorite,
                              size: 13,
                              color: Theme.of(context).primaryColor,
                            )),
                        const SizedBox(width: 5),
                        Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: Styles.containerCustom(),
                            child: Icon(
                              Icons.share,
                              size: 13,
                              color: Theme.of(context).primaryColor,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(
                    Icons.rate_review,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 6),
                  Text('20', style: Styles.letterCustom(13, true, 1)),
                  const SizedBox(width: 6),
                  Text('Reseñas', style: Styles.letterCustom(13, false, .6))
                ]),
                ImageStack(
                    showTotalCount: true,
                    extraCountTextStyle: GoogleFonts.quicksand(
                        fontSize: 12, color: Theme.of(context).primaryColor),
                    imageRadius: 30,
                    imageBorderColor: Colors.white,
                    imageCount: 7,
                    imageList: images,
                    totalCount: 20)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemGeneral2 extends StatelessWidget {
  final Producto producto;

  const ItemGeneral2({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 0),
                  ),
                ]),
            child: Row(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  width: 90,
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const Image(
                      image: NetworkImage(
                          'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(producto.nombre,
                            style: Styles.letterCustom(18, false, .8)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.7),
                                  shape: BoxShape.circle),
                              child: Text('3.6',
                                  style: Styles.letterCustom(10, false, -1.0)),
                            ),
                            RatingBar.builder(
                              initialRating: 3.5,
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
                            Text('(24)', style: Styles.letterCustom(10))
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  producto.descuentoC > 0 ||
                                          producto.descuentoP > 0
                                      ? Text('\$${producto.precio}',
                                          style: Styles.letterCustom(
                                              15, true, .3, true))
                                      : Container(),
                                  const SizedBox(width: 5),
                                  Text(
                                      /*'\$${this.producto.descuentoC > 0 ? double.parse((int.parse(this.producto.precio) - this.producto.descuentoC).toStringAsFixed(2)) : int.parse(this.producto.precio) - (int.parse(this.producto.precio) * this.producto.descuentoP / 100)}',*/
                                      "dsadsa",
                                      style: Styles.letterCustom(19, true, .8))
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 0),
                                      ),
                                    ]),
                                child: Text(
                                    producto.descuentoC > 0
                                        ? '\$ ' + producto.descuentoC.toString()
                                        : '% ' + producto.descuentoP.toString(),
                                    style: Styles.letterCustom(15, true, -0.1)),
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
        ],
      ),
    );
  }
}
