import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categoriaitem extends StatelessWidget {
  const Categoriaitem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.minHeight - 80,
                        child: const Image(
                          image: NetworkImage(
                              'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    /*Positioned(
                        top: 15,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.4),
                              borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color.fromRGBO(250, 91, 118, 1)),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )),*/
                    /*Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(255, 102, 48, 1)),
                            child: Text('2X1',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )))),*/
                    Positioned(
                      bottom: -5,
                      left: -4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(7),
                            bottomLeft: Radius.circular(7)),
                        child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Color.fromRGBO(43, 200, 185, 1),
                                ),
                                const SizedBox(width: 5),
                                Text('5.0',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 13,
                                        color: const Color.fromRGBO(
                                            62, 204, 191, 1)))
                              ],
                            )),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOMBRE DEL NEGOCIO',
                      style: GoogleFonts.quicksand(
                          color: Colors.blue, fontSize: 9),
                    ),
                    Text(
                      'Nombre del producto',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.7),
                          fontSize: 18),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('\$',
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('45.00',
                            style: GoogleFonts.quicksand(
                                color: Colors.grey, fontSize: 20)),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
