import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/helpers/haversine.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/lista_productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/widgets/producto_general2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StoreIndividual extends StatefulWidget {
  final Tienda tienda;

  const StoreIndividual({Key? key, required this.tienda}) : super(key: key);

  @override
  StoreIndividualState createState() => StoreIndividualState();
}

class StoreIndividualState extends State<StoreIndividual> {
  @override
  Widget build(BuildContext context) {
    final tiendaService = Provider.of<TiendaService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final direccionesService = Provider.of<DireccionesService>(context);
    double width = MediaQuery.of(context).size.width;
    final generalActions = Provider.of<GeneralActions>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        displacement: 100,
        strokeWidth: 3,
        onRefresh: () async {
          tiendaService.eliminarTiendaCache(nombre: widget.tienda.nombre);
          setState(() {});
        },
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                      primary: true,
                      stretch: true,
                      shadowColor: const Color.fromRGBO(245, 245, 247, 1),
                      floating: false,
                      forceElevated: true,
                      actionsIconTheme: const IconThemeData(color: Colors.red),
                      systemOverlayStyle: SystemUiOverlayStyle.light,
                      collapsedHeight: 85,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40))),
                      actions: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 14,
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);

                                generalActions.controllerNavigate(1);
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: const Icon(
                                    Icons.shopping_bag,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                            ),
                          ],
                        )
                      ],
                      leading: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 13),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.black,
                      elevation: 0,
                      pinned: true,
                      expandedHeight: 500,
                      flexibleSpace: LayoutBuilder(
                        builder: (ctx, cons) => FlexibleSpaceBar(
                          titlePadding: const EdgeInsets.all(20),
                          centerTitle: true,
                          title: Row(
                            children: [
                              AnimatedContainer(
                                margin: EdgeInsets.only(
                                    left: cons.biggest.height <= 200 ? 40 : 0),
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                duration: const Duration(milliseconds: 500),
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      width:
                                          cons.biggest.height <= 190 ? 50 : 70,
                                      height:
                                          cons.biggest.height <= 190 ? 50 : 70,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Hero(
                                        tag: widget.tienda.uid,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  widget.tienda.imagenPerfil,
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
                                                              .withOpacity(.15),
                                                          BlendMode.color,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              placeholder: (context, url) =>
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              25),
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                        color: Colors.black,
                                                      )),
                                              errorWidget:
                                                  (context, url, error) {
                                                return const Icon(Icons.error);
                                              }),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom:
                                          cons.biggest.height <= 190 ? 0 : 0,
                                      right: cons.biggest.height <= 190 ? 0 : 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Color.fromRGBO(0, 224, 242, 1)),
                                        child: const Icon(
                                          Icons.check,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  widget.tienda.nombre,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          collapseMode: CollapseMode.parallax,
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Image(
                                            image: CachedNetworkImageProvider(
                                                widget.tienda.fotografias),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                          stops: const [
                                            0.6,
                                            0.99,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0),
                                            Colors.black.withOpacity(1)
                                          ],
                                        )),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                          stops: const [
                                            0.0,
                                            0.5,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.center,
                                          colors: [
                                            Colors.black.withOpacity(.4),
                                            Colors.black.withOpacity(0)
                                          ],
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 100,
                                left: 145,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 7),
                                      child: RatingBar.builder(
                                        initialRating: 5,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) =>
                                            const FaIcon(
                                          FontAwesomeIcons.solidStar,
                                          color: Colors.white,
                                        ),
                                        itemSize: 12,
                                        unratedColor: Colors.grey,
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ),
                                    // Text(
                                    //   '( 17 )',
                                    //   style: GoogleFonts.quicksand(
                                    //       color: Colors.white,
                                    //       fontSize: 10,
                                    //       fontWeight: FontWeight.w600),
                                    // )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 47,
                                left: 145,
                                child: Text(
                                  'Restaurante',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              Positioned(
                                  bottom: 25,
                                  left: 140,
                                  child: direccionesService
                                          .direcciones.isNotEmpty
                                      ? SizedBox(
                                          width: width - 185,
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.place_outlined,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    '${(calculateDistance(lat1: widget.tienda.coordenadas.latitud, lon1: widget.tienda.coordenadas.longitud, lat2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lat, lon2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lng).toStringAsFixed(2))} km',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text('|',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color:
                                                                Colors.white)),
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(width: 1),
                                                  const Icon(
                                                    Icons.schedule,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      '${widget.tienda.tiempoEspera} min',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .white)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(children: [
                                          const Icon(
                                            Icons.place_outlined,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: width - 170,
                                            child: Text(widget.tienda.direccion,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.white,
                                                    fontSize: 13)),
                                          )
                                        ])),
                              Positioned(
                                  left: 140,
                                  bottom: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Colors.white)),
                                              Text(
                                                widget.tienda.online
                                                    ? 'Abierto'
                                                    : 'Cerrado',
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            DateFormat('h:mm a', 'es-MX')
                                                .format(widget
                                                    .tienda.horario.apertura
                                                    .toLocal())
                                                .toString(),
                                            style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text('    |   ',
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 14,
                                              )),
                                          Text(
                                            DateFormat('h:mm a', 'es-MX')
                                                .format(widget
                                                    .tienda.horario.cierre
                                                    .toLocal())
                                                .toString(),
                                            style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )),
                  SliverToBoxAdapter(
                    child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: tiendaService.tiendaCache(
                                    nombre: widget.tienda.nombre) ==
                                -1
                            ? FutureBuilder(
                                future: tiendaService.obtenerProductos(
                                    nombre: widget.tienda.nombre,
                                    id: widget.tienda.productos),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ListaProductosCategoria>>
                                        snapshot) {
                                  return LinearProgressIndicator(
                                    minHeight: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(.1),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  );
                                },
                              )
                            : AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                child: FutureBuilder(
                                  future: Future.delayed(
                                      const Duration(milliseconds: 1200)),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Colors.white,
                                        ),
                                        child: ListView.builder(
                                          primary: false,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                              top: 25,
                                              bottom: 45),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              ItemPorCategoria(
                                            categoria: tiendaService
                                                .productosCategoria[
                                                    tiendaService.tiendaCache(
                                                        nombre: widget
                                                            .tienda.nombre)]
                                                .productos[index],
                                            tienda: widget.tienda,
                                          ),
                                          itemCount: tiendaService
                                              .productosCategoria[
                                                  tiendaService.tiendaCache(
                                                      nombre:
                                                          widget.tienda.nombre)]
                                              .productos
                                              .length,
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(1),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              )),
                  )
                ],
              ),
            ),
            widget.tienda.online
                ? Container()
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 25),
                    child: Text(
                        '${widget.tienda.nombre} se encuentra fuera de servicio vuelve en su horario de atencion entre ${DateFormat('h:mm a', 'es-MX').format(widget.tienda.horario.apertura.toLocal()).toString()} y ${DateFormat('h:mm a', 'es-MX').format(widget.tienda.horario.cierre.toLocal()).toString()}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(color: Colors.white)),
                  )
          ],
        ),
      ),
    );
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }
}

class ItemPorCategoria extends StatefulWidget {
  final Tienda tienda;
  final ListaProductosCategoria categoria;
  const ItemPorCategoria({
    Key? key,
    required this.categoria,
    required this.tienda,
  }) : super(key: key);

  @override
  State<ItemPorCategoria> createState() => _ItemPorCategoriaState();
}

class _ItemPorCategoriaState extends State<ItemPorCategoria> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: AnimatedSize(
          duration: const Duration(seconds: 1),
          child: ExpansionPanelList(

            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
            elevation: 0,
            children: [
              ExpansionPanel(

                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    iconColor: Colors.blue,
                    
                    title: Text(
                      widget.categoria.titulo,
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.5), fontSize: 22),
                    ),
                  );
                },
                body: Column(
                  children: [
                    ListView.separated(
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) =>
                          ProductoGeneral2(
                        producto: widget.categoria.productos[index],
                        tienda: widget.tienda,
                      ),
                      itemCount: widget.categoria.productos.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 0),
                    )
                  ],
                ),
                isExpanded: _expanded,
                canTapOnHeader: true,
              ),
            ],
            animationDuration: const Duration(seconds: 1),
            dividerColor: Colors.grey,
            expansionCallback: (panelIndex, isExpanded) {
              _expanded = !_expanded;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
