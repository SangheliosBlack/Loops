import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgregarProductoView extends StatefulWidget {
  const AgregarProductoView(
      {Key? key,
      this.editar = false,
      this.precio = '',
      this.nombre = '',
      this.talla = '',
      this.cantidad = '',
      this.uid = ''})
      : super(key: key);
  final bool editar;
  final String precio;
  final String nombre;
  final String talla;
  final String cantidad;
  final String uid;

  @override
  AgregarProductoViewState createState() => AgregarProductoViewState();
}

class AgregarProductoViewState extends State<AgregarProductoView> {
  bool send = false;

  bool uno = false;
  bool dos = false;
  bool tres = false;
  bool cuatro = false;

  final unoCtrl = TextEditingController();
  final dosCtrl = TextEditingController();
  final tresCtrl = TextEditingController();
  final cuatroCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editar) {
      unoCtrl.text = widget.precio;
      dosCtrl.text = widget.nombre;
      tresCtrl.text = widget.talla;
      cuatroCtrl.text = widget.cantidad;

      uno = true;
      dos = true;
      tres = true;
      cuatro = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothProvider>(context);
    double width = MediaQuery.of(context).size.width;
    final tiendasService = Provider.of<TiendaService>(context);
    final generalService = Provider.of<GeneralActions>(context);
    final socioService = Provider.of<SocioService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          widget.editar
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    mostrarCarga(context);
                    final result = await socioService.eliminarProducto(
                        idListado: socioService.tienda.productos,
                        idProducto: widget.uid);
                    if (context.mounted) Navigator.pop(context);
                    if (result) {
                      final snackBar = SnackBar(
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.black,
                        content: Text(
                          'Producto eliminado.',
                          style: GoogleFonts.quicksand(),
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Navigator.pop(context);
                      }
                    } else {
                      final snackBar = SnackBar(
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.black,
                        content: Text(
                          'Error interno',
                          style: GoogleFonts.quicksand(),
                        ),
                      );

                      if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      margin: const EdgeInsets.only(right: 25),
                      child: Row(
                        children: [
                          Text(
                            'Eliminar',
                            style:
                                GoogleFonts.quicksand(color: Colors.blueGrey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ],
                      )),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  margin: const EdgeInsets.only(right: 25),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        margin: const EdgeInsets.only(right: 5),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: bluetoothService.isConnected
                                ? const Color.fromRGBO(41, 199, 184, 1)
                                : Colors.red,
                            shape: BoxShape.circle),
                        duration: const Duration(milliseconds: 400),
                      ),
                      const Icon(
                        Icons.print,
                        color: Colors.black,
                      ),
                    ],
                  ))
        ],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(widget.editar ? '' : 'Nuevo producto',
            style: GoogleFonts.quicksand(
              fontSize: 30,
              color: Colors.black,
            )),
      ),
      body: Container(
        margin: EdgeInsets.only(top: widget.editar ? 0 : 30),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                children: [
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
                          style: GoogleFonts.quicksand(color: Colors.black),
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
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 60, maxWidth: 60),
                            prefixIcon: AnimatedContainer(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: uno ? Colors.black : Colors.white,
                                  shape: BoxShape.circle),
                              duration: const Duration(milliseconds: 500),
                              child: Icon(
                                uno ? Icons.check : Icons.close,
                                color: uno ? Colors.white : Colors.black,
                                size: 18,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.blueGrey, fontSize: 15),
                            labelText: 'Precio',
                            errorStyle: GoogleFonts.quicksand(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(.4),
                                    width: 1)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: cuatroCtrl,
                          style: GoogleFonts.quicksand(color: Colors.black),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (valor) {
                            String nuevoValor = valor!.replaceAll('\$', '');
                            nuevoValor = nuevoValor.replaceAll(' ', '');
                            nuevoValor = nuevoValor.replaceAll(',', '');
                            if (nuevoValor.isEmpty) {
                              return 'Cantidad invalido';
                            } else {
                              if (nuevoValor.isNotEmpty &&
                                  double.parse(nuevoValor) >= 1) {
                                return null;
                              } else {
                                return 'Cantidad invalido';
                              }
                            }
                          },
                          onChanged: (valor) async {
                            if (valor.isNotEmpty) {
                              if (mounted) {
                                setState(() {
                                  cuatro = true;
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  cuatro = false;
                                });
                              }
                            }
                          },
                          keyboardType: TextInputType.number,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 60, maxWidth: 60),
                            prefixIcon: AnimatedContainer(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: cuatro ? Colors.black : Colors.white,
                                  shape: BoxShape.circle),
                              duration: const Duration(milliseconds: 500),
                              child: Icon(
                                cuatro ? Icons.check : Icons.close,
                                color: cuatro ? Colors.white : Colors.black,
                                size: 18,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.blueGrey, fontSize: 15),
                            labelText: 'Cantidad',
                            errorStyle: GoogleFonts.quicksand(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(.4),
                                    width: 1)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: dosCtrl,
                          style: GoogleFonts.quicksand(color: Colors.black),
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
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 60, maxWidth: 60),
                            prefixIcon: AnimatedContainer(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: dos ? Colors.black : Colors.white,
                                  shape: BoxShape.circle),
                              duration: const Duration(milliseconds: 500),
                              child: Icon(
                                dos ? Icons.check : Icons.close,
                                color: dos ? Colors.white : Colors.black,
                                size: 18,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.blueGrey, fontSize: 15),
                            labelText: 'Nombre',
                            errorStyle: GoogleFonts.quicksand(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(.4),
                                    width: 1)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: tresCtrl,
                          style: GoogleFonts.quicksand(color: Colors.black),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (valor) {
                            if (valor!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Valor invalido';
                            }
                          },
                          onChanged: (valor) async {
                            if (valor.isNotEmpty) {
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
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 60, maxWidth: 60),
                            prefixIcon: AnimatedContainer(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: tres ? Colors.black : Colors.white,
                                  shape: BoxShape.circle),
                              duration: const Duration(milliseconds: 500),
                              child: Icon(
                                tres ? Icons.check : Icons.close,
                                color: tres ? Colors.white : Colors.black,
                                size: 18,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.blueGrey, fontSize: 15),
                            labelText: 'Descripcion ( opcional )',
                            errorStyle: GoogleFonts.quicksand(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(.4),
                                    width: 1)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                    width: 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: send ? 300 : width - 50,
              height: 50,
              duration: const Duration(seconds: 1),
              child: ElevatedButton(
                onPressed: uno && dos && tres && cuatro && !send
                    ? widget.editar
                        ? () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            mostrarCarga(context);
                            setState(() {
                              if (mounted) {
                                send = true;
                              }
                            });
                            final resp = await tiendasService.editarProducto(
                                listaUid: socioService.tienda.productos,
                                nombre: dosCtrl.text.trim(),
                                precioCast: unoCtrl.text.trim(),
                                descripcion: tresCtrl.text.trim(),
                                productoUid: widget.uid,
                                cantidad: cuatroCtrl.text.trim());

                            if (resp) {
                              String precio =
                                  unoCtrl.text.trim().replaceAll('\$', '');
                              precio = precio.replaceAll(' ', '');
                              precio = precio.replaceAll(',', '');

                              socioService.editarProductoInterno(
                                cantidad: cuatroCtrl.text.trim(),
                                id: widget.uid,
                                nombre: dosCtrl.text.trim(),
                                precio: precio,
                                talla: tresCtrl.text.trim(),
                              );

                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.black,
                                content: Text(
                                  'Producto editado.',
                                  style: GoogleFonts.quicksand(),
                                ),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                await Future.delayed(
                                    const Duration(milliseconds: 400));
                                if (context.mounted) Navigator.pop(context);
                                if (context.mounted) Navigator.pop(context);
                              }
                            } else {
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Error al editar producto.',
                                  style: GoogleFonts.quicksand(),
                                ),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                                setState(() {
                                  if (mounted) {
                                    send = false;
                                  }
                                });
                              }
                            }
                          }
                        : () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            mostrarCarga(context);
                            setState(() {
                              if (mounted) {
                                send = true;
                              }
                            });
                            final producto =
                                await tiendasService.agregarNuevoProducto(
                                    lista: socioService.tienda.productos,
                                    nombre: dosCtrl.text.trim(),
                                    precio: unoCtrl.text.trim(),
                                    descripcion: tresCtrl.text.trim(),
                                    tienda: socioService.tienda.nombre,
                                    cantidad: cuatroCtrl.text.trim());

                            if (producto != null) {
                              socioService.agregarNuevoProducto(
                                  producto: producto);
                              generalService.controllerNavigate(2);

                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.black,
                                content: Text(
                                  '${producto.nombre} agregado a su inventario.',
                                  style: GoogleFonts.quicksand(),
                                ),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                await Future.delayed(
                                    const Duration(milliseconds: 400));
                                if (context.mounted) Navigator.pop(context);
                                if (context.mounted) Navigator.pop(context);
                              }
                            } else {
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Error al agregar nuevo producto',
                                  style: GoogleFonts.quicksand(),
                                ),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                                setState(() {
                                  if (mounted) {
                                    send = false;
                                  }
                                });
                              }
                            }
                          }
                    : null,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Theme.of(context).primaryColor),
                child: Text(
                  widget.editar ? 'Editar' : 'Agregar',
                  style: GoogleFonts.quicksand(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
