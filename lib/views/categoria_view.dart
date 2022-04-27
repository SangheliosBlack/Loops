import 'package:delivery/models/productos.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriaView extends StatelessWidget {
  final String titulo;
  const CategoriaView({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiendaProvider = Provider.of<TiendasService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*actions: [
          Container(
              margin: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.search))
        ],*/
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
        builder:
            (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: snapshot.hasData
                  ? ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductoGeneral(
                          producto: snapshot.data![index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        LinearProgressIndicator(
                          backgroundColor: Color.fromRGBO(234, 248, 248, 0),
                          color: Color.fromRGBO(62, 204, 191, 1),
                        )
                      ],
                    ));
        },
      ),
    );
  }
}
