import 'package:delivery/models/lista_productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/widgets/producto_general2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StoreIndividual extends StatefulWidget {
  final Tienda tienda;

  const StoreIndividual({Key? key, required this.tienda}) : super(key: key);

  @override
  _StoreIndividualState createState() => _StoreIndividualState();
}

class _StoreIndividualState extends State<StoreIndividual> {
  @override
  Widget build(BuildContext context) {
    final tiendaService = Provider.of<TiendasService>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
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
              collapsedHeight: 80,
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70))),
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(9),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black.withOpacity(.7),
                    size: 17,
                  ),
                ),
              ),
              backgroundColor: const Color.fromRGBO(62, 204, 191, 1),
              elevation: 0,
              pinned: true,
              expandedHeight: 350,
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
                            color: Colors.white, shape: BoxShape.circle),
                        duration: const Duration(milliseconds: 500),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              width: cons.biggest.height <= 190 ? 50 : 70,
                              height: cons.biggest.height <= 190 ? 50 : 70,
                              duration: const Duration(milliseconds: 300),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                  image: NetworkImage(
                                      'https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: cons.biggest.height <= 190 ? 0 : 0,
                              right: cons.biggest.height <= 190 ? 0 : 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(0, 224, 242, 1)),
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
                            const Positioned.fill(
                              child: ClipRRect(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image(
                                    image: NetworkImage(
                                        'https://images.otstatic.com/prod1/32412251/3/huge.jpg'),
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
                                    0.4,
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
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: 140,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 7),
                              child: RatingBar.builder(
                                initialRating: 4.5,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.white,
                                ),
                                itemSize: 12,
                                unratedColor: Colors.grey,
                                onRatingUpdate: (rating) {},
                              ),
                            ),
                            Text(
                              '( 17 )',
                              style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          left: 150,
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Restaurante',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5),
                                  RatingBar.builder(
                                    initialRating: 3.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                    ),
                                    itemSize: 13,
                                    unratedColor: Colors.grey,
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place_outlined,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '2.4 km Centro, Lagos de Moreno ',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )),
                      Positioned(
                          right: 15,
                          bottom: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Horario :',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.restore,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '10:00 PM',
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
            child: FutureBuilder(
              future: tiendaService.obtenerProductos(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ListaProductosCategoria>> snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: snapshot.hasData
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white,
                            ),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, top: 25, bottom: 45),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  ItemPorCategoria(
                                categoria: snapshot.data![index],
                              ),
                              itemCount: snapshot.data!.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 0),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                              child: LinearProgressIndicator(
                                color: Colors.white.withOpacity(1),
                                backgroundColor:
                                    const Color.fromRGBO(62, 204, 191, 1),
                              ),
                            ),
                          ));
              },
            ),
          )
        ],
      ),
    );
  }
}

class ItemPorCategoria extends StatefulWidget {
  final ListaProductosCategoria categoria;
  const ItemPorCategoria({
    Key? key,
    required this.categoria,
  }) : super(key: key);

  @override
  State<ItemPorCategoria> createState() => _ItemPorCategoriaState();
}

class _ItemPorCategoriaState extends State<ItemPorCategoria> {
  bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ExpansionPanelList(
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
          elevation: 0,
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        ProductoGeneral2(
                      producto: widget.categoria.productos[index],
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
          dividerColor: Colors.grey,
          expansionCallback: (panelIndex, isExpanded) {
            _expanded = !_expanded;
            setState(() {});
          },
        ),
      ),
    );
  }
}
