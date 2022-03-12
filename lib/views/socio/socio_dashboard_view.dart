import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/socio/editar_tienda_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SocioDashBoardView extends StatelessWidget {
  const SocioDashBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiendasService = Provider.of<TiendasService>(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 90, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Hero(
                        tag: tiendasService.tienda.uid,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const SizedBox(
                            width: 120,
                            height: 120,
                            child: Image(
                              image: NetworkImage(
                                  'https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditarTiendaView()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(.3))),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor),
                              child: const Icon(
                                Icons.settings,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
                Text(
                  tiendasService.tienda.nombre,
                  style: GoogleFonts.quicksand(fontSize: 30),
                ),
                SizedBox(
                  height: 93,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        const MiembroEquipo(),
                    itemCount: 1,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 170,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sin pedidos por ahora',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.4),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
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
}

class MiembroEquipo extends StatelessWidget {
  const MiembroEquipo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              color: Color.fromRGBO(62, 204, 191, 1),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Equipo',
            style: GoogleFonts.quicksand(),
          )
        ],
      ),
    );
  }
}
