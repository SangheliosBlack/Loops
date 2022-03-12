import 'package:delivery/global/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class VerProductoView extends StatelessWidget {
  const VerProductoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                        'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
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
                                    color:
                                        const Color.fromRGBO(40, 200, 184, 1),
                                    fontSize: 14)),
                          ),
                          const SizedBox(width: 4),
                          RatingBar.builder(
                            initialRating: 3.5,
                            itemSize: 17,
                            ignoreGestures: true,
                            minRating: 1,
                            direction: Axis.horizontal,
                            unratedColor:
                                const Color.fromRGBO(234, 248, 248, 1),
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Color.fromRGBO(40, 200, 184, 1),
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          Text('(24)',
                              style: Styles.letterCustom(12, false, .2))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 60,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const SizedBox(
                            height: 80,
                            width: 80,
                            child: Image(
                              image: NetworkImage(
                                  "https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg"),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        detailContainer(context)
      ],
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
}
