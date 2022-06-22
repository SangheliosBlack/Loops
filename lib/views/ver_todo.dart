import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/widgets/dashboard/carta_negocio.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerTodoView extends StatelessWidget {
  final String titulo;

  const VerTodoView({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final tiendaService = Provider.of<TiendasService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          titulo,
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(
              color: Colors.black.withOpacity(.8), fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        /*actions: [
          GestureDetector(
            onTap: () async {
              try {} catch (e) {
                debugPrint('Ningun lugar seleccionado');
              }
            },
            child: Container(
                height: 80,
                width: 45,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: const Center(
                        child: Icon(
                      Icons.search,
                      color: Colors.black,
                    )))),
          ),
        ],*/
      ),
      body: titulo == 'Establecimientos'
          ? FutureBuilder(
              future: tiendaService.verTodoTienda(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Tienda>> snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: snapshot.hasData
                        ? GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: snapshot.data?.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    mainAxisExtent: 311,
                                    maxCrossAxisExtent: width),
                            itemBuilder: (BuildContext context, int index) {
                              return CartaNegocio(
                                tienda: snapshot.data![index],
                                small: true,
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              LinearProgressIndicator(
                                minHeight: 1,
                                backgroundColor:
                                    Color.fromRGBO(234, 248, 248, 0),
                                color: Color.fromRGBO(62, 204, 191, 1),
                              )
                            ],
                          ));
              },
            )
          : FutureBuilder(
              future: tiendaService.verTodoProductos(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Producto>> snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: snapshot.hasData
                        ? ListView.separated(
                            padding: const EdgeInsets.all(20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProductoGeneral(
                                producto: snapshot.data![index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              height: 10,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              LinearProgressIndicator(
                                backgroundColor:
                                    Color.fromRGBO(234, 248, 248, 0),
                                color: Color.fromRGBO(62, 204, 191, 1),
                              )
                            ],
                          ));
              },
            ),
    );
  }
}
