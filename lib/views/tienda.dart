import 'package:delivery/models/lista_productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
              foregroundColor: Colors.red,
              primary: true,
              stretch: true,
              shadowColor: const Color.fromRGBO(245, 245, 247, 1),
              floating: false,
              forceElevated: true,
              actionsIconTheme: const IconThemeData(color: Colors.red),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              collapsedHeight: 80,
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
              backgroundColor: const Color.fromRGBO(
                62,
                204,
                191,
                1,
              ),
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70))),
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
                              width: cons.biggest.height <= 190 ? 50 : 85,
                              height: cons.biggest.height <= 190 ? 50 : 85,
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
                              bottom: cons.biggest.height <= 190 ? 0 : 5,
                              right: cons.biggest.height <= 190 ? 0 : 5,
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
                          style: GoogleFonts.quicksand(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: cons.biggest.height <= 190
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      )
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    color: const Color.fromRGBO(245, 245, 247, 1),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35)),
                        ),
                        Stack(
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              height: 260,
                              child: Image(
                                image: NetworkImage(
                                    'https://traveler.marriott.com/es/wp-content/uploads/sites/2/2019/10/Maverick_interior.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: 260,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                stops: const [
                                  0.7,
                                  0.99,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(1)
                                ],
                              )),
                            )
                          ],
                        ),
                        /*Positioned(
                          bottom: 140,
                          right: 20,
                          child: Container(
                            width: 45,
                            height: 45,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.3),
                                shape: BoxShape.circle),
                            child: const CircleAvatar(
                              backgroundColor: Color.fromRGBO(253, 96, 122, 1),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),*/
                        Positioned(
                          bottom: 50,
                          left: 170,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 7),
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 13,
                                ),
                              ),
                              Text(
                                '5.0',
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey.withOpacity(.7),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '( 17 )',
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey.withOpacity(.4),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            right: 25,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          245, 245, 247, 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delivery_dining_outlined,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '45 min',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black.withOpacity(.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          245, 245, 247, 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        size: 21,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '10:00 PM',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black.withOpacity(.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          SliverToBoxAdapter(
            child: Column(
              children: [
                FutureBuilder(
                  future: tiendaService.obtenerProductos(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ListaProductosCategoria>> snapshot) {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        child: snapshot.hasData
                            ? ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        ItemPorCategoria(
                                  categoria: snapshot.data![index],
                                ),
                                itemCount: snapshot.data!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 20),
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: const CircularProgressIndicator(
                                  color: Color.fromRGBO(62, 204, 191, 1),
                                ),
                              ));
                  },
                ),
              ],
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
                  title: Row(
                    children: [
                      const Icon(
                        Icons.lunch_dining,
                        size: 20,
                        color: Color.fromRGBO(62, 204, 191, 1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.categoria.titulo,
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(.5),
                            fontSize: 22),
                      ),
                    ],
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
                        ProductoGeneral(
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
