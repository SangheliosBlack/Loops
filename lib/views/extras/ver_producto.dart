import 'package:delivery/global/styles.dart';
import 'package:delivery/views/notificaciones_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerProductoView extends StatelessWidget {
  const VerProductoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          right: 15,
                          top: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromRGBO(62, 204, 191, 1),
                            ),
                            child: Center(
                              child: Text(
                                '5',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
            leadingWidth: 112,
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
                            '0.00',
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
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: const Image(
                          image: NetworkImage(
                              'https://www.recetasderechupete.com/wp-content/uploads/2018/06/alitas-de-pollo-horno.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.black.withOpacity(.0),
                        Colors.white.withOpacity(.0),
                      ])),
                    ),
                  )),
                ],
              ),
            ),
            Container(
              height: 420,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text('Nombre del lugar',
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
                      Text('Nombre del producto',
                          style: GoogleFonts.quicksand(
                              fontSize: 25,
                              color: const Color.fromRGBO(83, 84, 85, 1))),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500,',
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.quicksand(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text('Tamaño', style: GoogleFonts.quicksand(fontSize: 15)),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 30),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(200, 201, 203, 1),
                        borderRadius: BorderRadius.circular(40)),
                    child: Text('250g',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(.2)),
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text('1',
                                style: GoogleFonts.quicksand(fontSize: 20))),
                        Container(
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
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
                                    fontSize: 25,
                                  )),
                              const SizedBox(width: 3),
                              Text('52.22',
                                  style: GoogleFonts.quicksand(
                                    color: const Color.fromRGBO(65, 65, 66, 1),
                                    fontSize: 40,
                                  )),
                            ],
                          )
                        ],
                      ),
                      Container(
                          width: 230,
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(.2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.moped_sharp,
                                color: Colors.black.withOpacity(.8),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                'Agregar',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black.withOpacity(.8),
                                    fontSize: 20),
                              )
                            ],
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
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
}
