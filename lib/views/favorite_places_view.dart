import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FavoritePlacesView extends StatelessWidget {
  const FavoritePlacesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(viewportFraction: 1);
    final productosService = Provider.of<LlenarPantallasService>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(top: 15, bottom: 25),
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "16",
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Resultados",
                        style: GoogleFonts.quicksand(
                            color: Colors.black, fontSize: 30),
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Reciente',
                        style: GoogleFonts.quicksand(color: Colors.black),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.unfold_more)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: controller,
                itemBuilder: (BuildContext context, int index) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProductoGeneral(
                        producto: productosService.productos[0].productos[index])),
                itemCount: productosService.productos.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: SmoothPageIndicator(
                count: 5,
                effect: ExpandingDotsEffect(
                    activeDotColor: const Color.fromRGBO(40, 40, 40, 1),
                    dotColor: Colors.black.withOpacity(.1),
                    dotHeight: 8,
                    dotWidth: 15,
                    spacing: 7),
                controller: controller,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              faviItem(context),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 25),
                          itemCount: 3),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget faviItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 190,
                    child: Image(
                      image: NetworkImage(
                          'https://traveler.marriott.com/es/wp-content/uploads/sites/2/2019/10/Maverick_interior.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const SizedBox(
                              height: 60,
                              width: 60,
                              child: Image(
                                image: NetworkImage(
                                    "https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg"),
                                fit: BoxFit.cover,
                              )),
                        ),
                      )),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.3),
                            shape: BoxShape.circle),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(252, 95, 121, 1)),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nombre",
                  style: GoogleFonts.quicksand(
                      fontSize: 27, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(234, 250, 250, 1)),
                      child: const Icon(
                        Icons.star,
                        size: 17,
                        color: Color.fromRGBO(42, 200, 185, 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "5.0",
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text("45 - 60 min",
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(width: 10),
                Text("·  Delivery fee 451.2",
                    style: GoogleFonts.quicksand(color: Colors.grey))
              ],
            ),
          )
        ],
      ),
    );
  }
}
