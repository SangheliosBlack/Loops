import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/categorias_response.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/tienda.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriaView extends StatelessWidget {
  final String titulo;
  const CategoriaView({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiendaProvider = Provider.of<TiendaService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titulo,
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 25),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: tiendaProvider.listaCategorias(filtro: titulo),
        builder: (BuildContext context, AsyncSnapshot<Categorias> snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: snapshot.hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 100,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var tienda = snapshot.data!.tiendas[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StoreIndividual(
                                                tienda: tienda,
                                              )),
                                    );
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                          height: 75,
                                          width: 75,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: tienda.imagenPerfil,
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            Colors.black
                                                                .withOpacity(
                                                                    .15),
                                                            BlendMode.color,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(100),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 1,
                                                          color: Colors.black,
                                                        )),
                                                errorWidget:
                                                    (context, url, error) {
                                                  return const Icon(
                                                      Icons.error);
                                                }),
                                          )),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: 75,
                                        child: Text(
                                          tienda.nombre,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.quicksand(),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.tiendas.length,
                              separatorBuilder: (_, __) => const SizedBox(
                                width: 5,
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: snapshot.data!.productos.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProductoGeneral(
                                producto: snapshot.data!.productos[index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          minHeight: 1,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.1),
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ));
        },
      ),
    );
  }
}
