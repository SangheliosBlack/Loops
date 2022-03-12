import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery/models/productos.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditarProducto extends StatefulWidget {
  final Producto producto;

  const EditarProducto({Key? key, required this.producto}) : super(key: key);

  @override
  State<EditarProducto> createState() => _EditarProductoState();
}

double rating = 10;
double cantidad = 20;

class _EditarProductoState extends State<EditarProducto> {
  @override
  Widget build(BuildContext context) {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter(symbol: "\$");
    double width = MediaQuery.of(context).size.width;
    return Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ListView(
              
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mis productos',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600, color: Colors.grey)),
                      Text('Editar producto',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: const [
                         SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image(
                            image: NetworkImage(
                                'https://saboryestilo.com.mx/wp-content/uploads/2019/09/platillos-tipicos-de-mexico1-1200x675.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                         Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                          style: GoogleFonts.quicksand(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          initialValue: widget.producto.nombre,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: widget.producto.nombre,
                              hintStyle: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.6),
                                  fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).primaryColor)),
                              labelText: 'Nombre',
                              labelStyle: GoogleFonts.quicksand(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black.withOpacity(.1))))),
                      const SizedBox(height: 25),
                      TextFormField(
                          initialValue: formatter
                              .format(widget.producto.precio.toString()),
                          style: GoogleFonts.quicksand(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          inputFormatters: <TextInputFormatter>[formatter],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: formatter.format(
                                  widget.producto.precio.toString()),
                              hintStyle: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).primaryColor)),
                              labelText: 'Precio',
                              labelStyle: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black.withOpacity(.1))))),
                      const SizedBox(height: 25),
                      TextFormField(
                          style: GoogleFonts.quicksand(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          initialValue: widget.producto.nombre,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: widget.producto.nombre,
                              hintStyle: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.6),
                                  fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).primaryColor)),
                              labelText: 'Descripcion',
                              labelStyle: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black.withOpacity(.1))))),
                      const SizedBox(height: 15),
                      Text('Descuentos',
                          style: GoogleFonts.quicksand(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('-Porcentaje',
                          style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)),
                      const SizedBox(width: 5),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  double.parse(rating.toString())
                                          .toStringAsFixed(0) +
                                      "%",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(width: 5),
                                Text('(porcentaje maximo 90%)',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                              ],
                            ),
                            Text(
                              'Precio final',
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                            valueIndicatorColor: Theme.of(context).primaryColor,
                            valueIndicatorTextStyle:
                                const TextStyle(backgroundColor: Colors.transparent),
                            overlayShape: SliderComponentShape.noOverlay),
                        child: Slider.adaptive(
                            min: 0.0,
                            divisions: 18,
                            max: 90,
                            label: double.parse(rating.toString())
                                .toStringAsFixed(0),
                            value: rating,
                            inactiveColor:
                                Theme.of(context).primaryColor.withOpacity(.3),
                            thumbColor: Colors.black,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (valor) {
                              if (mounted) {
                                setState(() {
                                  rating = valor;
                                });
                              }
                            }),
                      ),
                      const SizedBox(height: 10),
                      Text('-Cantidad',
                          style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "\$" +
                                      double.parse(rating.toString())
                                          .toStringAsFixed(0),
                                  style: GoogleFonts.quicksand(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(width: 5),
                                Text('(maximo ${widget.producto.precio})',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                              ],
                            ),
                            Text(
                              'Precio final',
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                            valueIndicatorColor: Theme.of(context).primaryColor,
                            valueIndicatorTextStyle:
                                const TextStyle(backgroundColor: Colors.transparent),
                            overlayShape: SliderComponentShape.noOverlay),
                        child: Slider.adaptive(
                            min: 0.0,
                            divisions: 18,
                            max: 90,
                            label: double.parse(rating.toString())
                                .toStringAsFixed(0),
                            value: rating,
                            inactiveColor:
                                Theme.of(context).primaryColor.withOpacity(.3),
                            thumbColor: Colors.black,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (valor) {
                              if (mounted) {
                                setState(() {
                                  rating = valor;
                                });
                              }
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Disponible',
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Switch(
                                        activeTrackColor:
                                            Theme.of(context).primaryColor,
                                        activeColor: Colors.white,
                                        onChanged: (bool value) async {},
                                        value: true),
                                  ),
                                ]),
                            Text('Algun texto para que se entienda',
                                style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: width,
              child: Container(
                margin: const EdgeInsets.all(15),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
          )
        ],
      );
  }
}
