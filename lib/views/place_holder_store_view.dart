import 'package:delivery/global/styles.dart';
import 'package:delivery/widgets/global.dart';
import 'package:delivery/widgets/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';

class PlaceHolderStoreView extends StatelessWidget {
  const PlaceHolderStoreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg",
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg",
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg",
      "https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg"
    ];
    PageController controller = PageController(viewportFraction: .85);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarrouselGlobal(
                  controller: controller,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: Styles.containerCustom(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: const Image(
                                  image: NetworkImage(
                                      'https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/143249104_3707105892742804_3804911765651632609_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=3PsTxqdKhcAAX9ZhSZa&_nc_ht=scontent.fagu2-1.fna&oh=e6a1a56ec4551768e316c9b35e9fc21a&oe=614557EC'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre',
                                    style: Styles.letterCustom(25, true)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
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
                                          FontAwesomeIcons.wifi,
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
                                          FontAwesomeIcons.motorcycle,
                                          size: 13,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: Styles.containerCustom(),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 17,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              const SizedBox(width: 10),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: Styles.containerCustom(),
                                  child: Icon(
                                    Icons.share,
                                    size: 17,
                                    color: Theme.of(context).primaryColor,
                                  ))
                            ],
                          )
                        ],
                      ),
                      AnimatedContainer(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          height: 80,
                          duration: const Duration(milliseconds: 500),
                          child: Stack(
                            children: [
                              Text(
                                  'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas "Letraset", las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejem',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(.6),
                                      height: 1.5)),
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                      const Color(0xffEEEEEE).withOpacity(.0),
                                      const Color(0xffEEEEEE).withOpacity(.9)
                                    ])),
                              )
                            ],
                          )),
                      Row(
                        children: [
                          Text(
                            'Expandir',
                            style: Styles.letterCustom(14, false, .6),
                          ),
                          Icon(
                            Icons.expand_more,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.rate_review,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Text('20', style: Styles.letterCustom(15, true)),
                              const SizedBox(width: 5),
                              Text('Reviews',
                                  style: Styles.letterCustom(15, false, 0.4))
                            ]),
                            ImageStack(
                                backgroundColor: Theme.of(context).primaryColor,
                                showTotalCount: true,
                                extraCountTextStyle:
                                    Styles.letterCustom(11, false, -0.1),
                                extraCountBorderColor:
                                    Theme.of(context).primaryColor,
                                imageRadius: 33,
                                imageBorderColor: Colors.white,
                                imageCount: 7,
                                imageList: images,
                                totalCount: 20)
                          ],
                        ),
                      ),
                      Container(
                        decoration: Styles.containerCustom(),
                        margin: const EdgeInsets.only(top: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const SizedBox(height: 200, child: MapWidget())),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect useritem() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: const SizedBox(
        width: 40,
        height: 40,
        child: Image(
          image: NetworkImage(
              'https://img.freepik.com/foto-gratis/hombre-guapo-caucasico-aislado-pared-beige-dando-gesto-pulgares-arriba_1368-92335.jpg?size=626&ext=jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
