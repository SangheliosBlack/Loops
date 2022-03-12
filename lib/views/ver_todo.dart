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
            title: Text(
              titulo,
              textAlign: TextAlign.start,
              style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () async {
                  try {} catch (e) {
                    debugPrint('Ningun lugar seleccionado');
                  }
                },
                child: Container(
                    height: 80,
                    width: 45,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: const Center(
                            child: Icon(
                          Icons.search,
                          color: Colors.black,
                        )))),
              ),
            ],
          ),
        ),
      ),
      body: titulo == 'Establecimientos'
          ? FutureBuilder(
              future: tiendaService.verTodoTienda(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Tienda>> snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(seconds: 0),
                    child: snapshot.hasData
                        ? GridView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: snapshot.data?.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    mainAxisExtent: 227,
                                    maxCrossAxisExtent: width / 2),
                            itemBuilder: (BuildContext context, int index) {
                              return CartaNegocio(
                                index: index,
                                tienda: snapshot.data![index],
                                small: false,
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              LinearProgressIndicator(
                                backgroundColor:
                                    Color.fromRGBO(234, 248, 248, 1),
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
                    duration: const Duration(seconds: 0),
                    child: snapshot.hasData
                        ? ListView.separated(
                            padding: const EdgeInsets.all(20),
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
                                    Color.fromRGBO(234, 248, 248, 1),
                                color: Color.fromRGBO(62, 204, 191, 1),
                              )
                            ],
                          ));
              },
            ),
    );
  }
}
