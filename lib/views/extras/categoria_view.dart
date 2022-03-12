import 'package:delivery/models/categorias_response.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/categoria_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriaView extends StatelessWidget {
  final String titulo;
  const CategoriaView({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiendaProvider = Provider.of<TiendasService>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ]),
          child: AppBar(
            centerTitle: true,
            title: Text(
              titulo,
              style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          FutureBuilder(
            future: tiendaProvider.listaCategorias(filtro: titulo),
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              return AnimatedSwitcher(
                  duration: const Duration(seconds: 0),
                  child: snapshot.hasData
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: StaggeredGrid.count(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: generarLista(snapshot.data!)),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            LinearProgressIndicator(
                              backgroundColor: Color.fromRGBO(234, 248, 248, 1),
                              color: Color.fromRGBO(62, 204, 191, 1),
                            )
                          ],
                        ));
            },
          ),
        ],
      ),
    );
  }

  List<Widget> generarLista(List<Item> lista) {
    return lista.map((e) {
      if (e.index == 1) {
        return const StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 4,
          child: Categoriaitem(),
        );
      } else if (e.index == 2) {
        return const StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Categoriaitem(),
        );
      } else if (e.index == 3) {
        return const StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Categoriaitem(),
        );
      } else if (e.index == 4) {
        return const StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 3,
          child: Categoriaitem(),
        );
      } else if (e.index == 5) {
        return const StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Categoriaitem(),
        );
      } else {
        return const StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Categoriaitem(),
        );
      }
    }).toList();
  }
}
