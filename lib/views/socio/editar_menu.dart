import 'package:delivery/global/styles.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/extras/nuevo_producto_view.dart';
import 'package:delivery/widgets/modals/editar_producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditarMenuView extends StatelessWidget {
  const EditarMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F6),
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Mis productos',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              agregarProducto(context);
            },
            child: Container(
                height: 80,
                width: 45,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(.2))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: const Center(
                        child: Icon(
                      Icons.add,
                      color: Colors.black,
                    )))),
          ),
        ],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: ListaProductos(),
      ),
    );
  }
}

agregarProducto(BuildContext context) async {
  showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: false,
      context: context,
      enableDrag: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      builder: (builder) {
        return const AgregarProductoView();
      });
}

class ListaProductos extends StatelessWidget {
  const ListaProductos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tienda = Provider.of<TiendasService>(context, listen: false);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => ItemGeneralSocio(
        producto: tienda.tienda.listaProductos[index],
      ),
      itemCount: tienda.tienda.listaProductos.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
    );
  }
}

class ItemGeneralSocio extends StatelessWidget {
  final Producto producto;

  const ItemGeneralSocio({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showInfo2(context, producto);
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: Styles.containerCustom(),
            child: Row(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  width: 90,
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const Image(
                      image: NetworkImage(
                          'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(producto.nombre,
                            style: Styles.letterCustom(18, true, 1)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(235, 248, 248, 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.star,
                                size: 15,
                                color: Color.fromRGBO(43, 200, 185, 1),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text('5.0', style: Styles.letterCustom(12, true, 1))
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$50.00',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.withOpacity(.4),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                      )),
                                  const SizedBox(width: 5),
                                  Text('\$45.00',
                                      style: Styles.letterCustom(19, true, .8))
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(255, 240, 235, 1)),
                                child: Text('10%',
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromRGBO(
                                            255, 102, 48, 1),
                                        fontSize: 15)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  showInfo2(BuildContext context, Producto producto) async =>
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          backgroundColor: Colors.white,
          builder: (builder) {
            return EditarProducto(
              producto: producto,
            );
          });
}
