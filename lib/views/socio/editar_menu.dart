import 'package:delivery/models/tienda.dart';
import 'package:delivery/widgets/producto_general_socio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditarMenuView extends StatelessWidget {
  final Tienda tienda;

  const EditarMenuView({Key? key, required this.tienda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Mis productos',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 17),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Producto',
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(0.8), fontSize: 25),
                    ),
                    Text(
                      'Precio',
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(0.8), fontSize: 25),
                    )
                  ],
                ),
              ),
              ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    ProductoGeneralSocio(
                  producto: tienda.listaProductos[index],
                ),
                itemCount: tienda.listaProductos.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    color: Colors.grey.withOpacity(.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
