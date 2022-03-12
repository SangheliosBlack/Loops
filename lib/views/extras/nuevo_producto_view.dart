import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgregarProductoView extends StatefulWidget {
  const AgregarProductoView({Key? key}) : super(key: key);

  @override
  _AgregarProductoViewState createState() => _AgregarProductoViewState();
}

class _AgregarProductoViewState extends State<AgregarProductoView> {
  bool uno = false;
  bool dos = false;
  bool tres = false;

  final unoCtrl = TextEditingController();
  final dosCtrl = TextEditingController();
  final tresCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tiendasService = Provider.of<TiendasService>(context, listen: true);
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 30),
            child: Row(
              children: [
                const Icon(
                  Icons.fiber_new_outlined,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text('Nuevo producto!',
                    style: GoogleFonts.quicksand(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Form(
            child: Column(
              children: [
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    CurrencyTextInputFormatter(
                      decimalDigits: 2,
                      symbol: '\$ ',
                    ),
                  ],
                  controller: unoCtrl,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.7)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valor) {
                    String nuevoValor = valor!.replaceAll('\$', '');
                    nuevoValor = nuevoValor.replaceAll(' ', '');
                    nuevoValor = nuevoValor.replaceAll(',', '');
                    if (nuevoValor.isEmpty) {
                      return 'Precio invalido';
                    } else {
                      if (nuevoValor.isNotEmpty &&
                          double.parse(nuevoValor) >= 10) {
                        return null;
                      } else {
                        return 'Precio invalido';
                      }
                    }
                  },
                  onChanged: (valor) async {
                    if (valor.isNotEmpty && valor.length >= 6) {
                      if (mounted) {
                        setState(() {
                          uno = true;
                        });
                      }
                    } else {
                      if (mounted) {
                        setState(() {
                          uno = false;
                        });
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: false,
                    selectAll: false,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(.1),
                    prefixIconConstraints:
                        const BoxConstraints(maxHeight: 60, maxWidth: 60),
                    prefixIcon: AnimatedContainer(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: uno
                              ? const Color.fromRGBO(62, 204, 191, 1)
                              : const Color.fromRGBO(255, 103, 50, 1),
                          shape: BoxShape.circle),
                      duration: const Duration(milliseconds: 500),
                      child: Icon(
                        uno ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 2)),
                    labelStyle: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Precio',
                    errorStyle: GoogleFonts.quicksand(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: dosCtrl,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.7)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valor) {
                    if (valor!.isNotEmpty && valor.length >= 6) {
                      return null;
                    } else {
                      return 'Valor invalido';
                    }
                  },
                  onChanged: (valor) async {
                    if (valor.isNotEmpty && valor.length >= 6) {
                      if (mounted) {
                        setState(() {
                          dos = true;
                        });
                      }
                    } else {
                      if (mounted) {
                        setState(() {
                          dos = false;
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(.1),
                    prefixIconConstraints:
                        const BoxConstraints(maxHeight: 60, maxWidth: 60),
                    prefixIcon: AnimatedContainer(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: dos
                              ? const Color.fromRGBO(62, 204, 191, 1)
                              : const Color.fromRGBO(255, 103, 50, 1),
                          shape: BoxShape.circle),
                      duration: const Duration(milliseconds: 500),
                      child: Icon(
                        dos ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 2)),
                    labelStyle: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Nombre',
                    errorStyle: GoogleFonts.quicksand(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: tresCtrl,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.7)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valor) {
                    if (valor!.isNotEmpty && valor.length >= 10) {
                      return null;
                    } else {
                      return 'Valor invalido';
                    }
                  },
                  onChanged: (valor) async {
                    if (valor.isNotEmpty && valor.length >= 10) {
                      if (mounted) {
                        setState(() {
                          tres = true;
                        });
                      }
                    } else {
                      if (mounted) {
                        setState(() {
                          tres = false;
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(.1),
                    prefixIconConstraints:
                        const BoxConstraints(maxHeight: 60, maxWidth: 60),
                    prefixIcon: AnimatedContainer(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: tres
                              ? const Color.fromRGBO(62, 204, 191, 1)
                              : const Color.fromRGBO(255, 103, 50, 1),
                          shape: BoxShape.circle),
                      duration: const Duration(milliseconds: 500),
                      child: Icon(
                        tres ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 2)),
                    labelStyle: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Descripcion',
                    errorStyle: GoogleFonts.quicksand(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(.0), width: 1)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: uno && dos && tres
                  ? () async {
                      final producto =
                          await tiendasService.agregarNuevoProducto(
                            lista: tiendasService.tienda.productos,
                              nombre: dosCtrl.text.trim(),
                              precio: unoCtrl.text.trim(),
                              descripcion: tresCtrl.text.trim());

                      if (producto != null) {
                        Navigator.pop(context);
                      } else {}
                    }
                  : null,
              child: Text(
                'Agregar',
                style: GoogleFonts.quicksand(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  primary: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
