import 'package:delivery/models/tienda.dart';
import 'package:delivery/widgets/producto_general.dart';
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
      body:  AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child:ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => ProductoGeneral(
        producto:tienda.listaProductos[index],
      ),
      itemCount: tienda.listaProductos.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
    ),
      ),
    );
  }
}

