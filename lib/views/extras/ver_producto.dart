import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/lista_opciones.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerProductoView extends StatefulWidget {
  final bool soloTienda;
  const VerProductoView(
      {Key? key, required this.producto, this.soloTienda = false})
      : super(key: key);

  final Producto producto;

  @override
  State<VerProductoView> createState() => _VerProductoViewState();
}

class _VerProductoViewState extends State<VerProductoView> {
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (authService.listadoTemp.isEmpty) {
          return true;
        } else {
          authService.vaciarElementosTemp();
          return true;
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: true,
              /*actions: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificacionesView()),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          width: 45,
                          height: 45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 5,
                            top: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: authService.totalPiezas() == 0 ? 0 : 1,
                              child: Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromRGBO(62, 204, 191, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    authService.totalPiezas().toString(),
                                    style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ]*/
              leadingWidth: 350,
              leading: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (authService.listadoTemp.isEmpty) {
                      Navigator.pop(context);
                    } else {
                      authService.vaciarElementosTemp();
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )
                      ],
                    ),
                  )),
              backgroundColor: Colors.white,
              elevation: 0),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: Hero(
                    tag: widget.soloTienda
                        ? widget.producto.nombre
                        : widget.producto.id,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: const Image(
                          image: CachedNetworkImageProvider(
                              'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(widget.producto.tienda,
                        style: GoogleFonts.quicksand(
                            fontSize: 14, color: Colors.black.withOpacity(.8))),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '4.9',
                          style: GoogleFonts.playfairDisplay(
                              color: const Color.fromRGBO(62, 204, 191, 1),
                              height: .8,
                              fontSize: 30),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(widget.producto.nombre,
                            style: GoogleFonts.quicksand(
                                fontSize: 25,
                                color: const Color.fromRGBO(83, 84, 85, 1))),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500,',
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                          color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              widget.producto.opciones.isEmpty
                  ? Container()
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final Opcion opcion = widget.producto.opciones[index];
                        return ListadoOpcinesWidget(
                          index: index,
                          opcion: opcion,
                        );
                      },
                      itemCount: widget.producto.opciones.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 15,
                      ),
                    ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: cantidad > 1
                          ? () {
                              if (mounted) {
                                setState(() {
                                  cantidad--;
                                });
                              }
                            }
                          : null,
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: cantidad == 0
                              ? Border.all(
                                  width: 1, color: Colors.red.withOpacity(.8))
                              : Border.all(
                                  width: 1,
                                  color: Colors.grey
                                      .withOpacity(cantidad > 1 ? .2 : .1)),
                        ),
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          Icons.remove,
                          color: cantidad == 0
                              ? Colors.red.withOpacity(.8)
                              : Colors.grey.withOpacity(cantidad > 1 ? 1 : .4),
                        ),
                      ),
                    ),
                    Container(
                        width: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(cantidad.toString(),
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                  fontSize: 30)),
                        )),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (cantidad < 15) {
                          if (mounted) {
                            setState(() {
                              cantidad++;
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(.2)),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text('Total :',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.grey)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$',
                                      style: GoogleFonts.playfairDisplay(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromRGBO(65, 65, 66, 1),
                                        fontSize: 19,
                                      )),
                                  const SizedBox(width: 3),
                                  Row(
                                    children: [
                                      Text(
                                          (widget.producto.precio * cantidad)
                                              .toStringAsFixed(2),
                                          style: GoogleFonts.quicksand(
                                            color: const Color.fromRGBO(
                                                65, 65, 66, 1),
                                            fontSize: 25,
                                          )),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          authService.calcularOpcionesExtra(
                                          opciones: widget.producto.opciones) *
                                      cantidad >
                                  0
                              ? Row(
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 3),
                                            Center(
                                              child: Text('+',
                                                  style: GoogleFonts
                                                      .playfairDisplay(
                                                    color: Colors.blue,
                                                    fontSize: 17,
                                                  )),
                                            ),
                                            const SizedBox(width: 3),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Extra :',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.blue)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    (authService.calcularOpcionesExtra(
                                                                opciones: widget
                                                                    .producto
                                                                    .opciones) *
                                                            cantidad)
                                                        .toStringAsFixed(2),
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      color: Colors.blue,
                                                      fontSize: 25,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: authService.listadoTemp.fold<num>(
                                      0,
                                      (previousValue, element) =>
                                          element.listado.length +
                                          previousValue) >=
                                  widget.producto.opciones.fold<num>(
                                      0,
                                      (previousValue, element) =>
                                          element.minimo + previousValue)
                              ? () async {
                                  calculandoAlerta(context);
                                  await authService.agregarProductoCesta(
                                      producto: widget.producto,
                                      cantidad: cantidad,
                                      listado: opcionesFinales(
                                          opciones: authService.listadoTemp));
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                    content: Text(
                                      '${widget.producto.nombre} agregado',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              : null,
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(left: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.black.withOpacity(authService
                                                  .listadoTemp
                                                  .fold<num>(
                                                      0,
                                                      (previousValue, element) =>
                                                          element.listado.length +
                                                          previousValue) >=
                                              widget.producto.opciones.fold<num>(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.minimo +
                                                      previousValue)
                                          ? .8
                                          : .1))),
                              child: Center(
                                child: Text(
                                  'Agregar',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black.withOpacity(authService
                                                  .listadoTemp
                                                  .fold<num>(
                                                      0,
                                                      (previousValue, element) =>
                                                          element
                                                              .listado.length +
                                                          previousValue) >=
                                              widget.producto.opciones.fold<num>(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.minimo +
                                                      previousValue)
                                          ? .8
                                          : .1),
                                      fontSize: 20),
                                ),
                              )),
                        );
                      }),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> opcionesFinales({required List<ListadoOpcionesTemp> opciones}) {
    List<List<String>> listado = [];
    for (var element in opciones) {
      listado.add(element.listado);
    }

    var listaExpanded = listado.expand((x) => x).toList();

    return listaExpanded;
  }

  String titulos({required List<Opcion> opciones}) {
    var titulos = '';

    for (var i = 0; i <= opciones.length - 1; i++) {
      if (i > 0) {
        titulos = titulos + 'y ${opciones[i].titulo}';
      } else {
        titulos = titulos + '${opciones[i].titulo} ';
      }
    }

    return '$titulos son campos necesarios';
  }
}

class ListadoOpcinesWidget extends StatelessWidget {
  const ListadoOpcinesWidget(
      {Key? key, required this.opcion, required this.index})
      : super(key: key);
  final Opcion opcion;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(opcion.titulo,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                    )),
                /*Text(
                    authService.listadoTemp.indexWhere(
                                (element) => element.index == index) ==
                            index
                        ? authService
                            .listadoTemp[authService.listadoTemp.indexWhere(
                                (element) => element.index == index)]
                            .listado
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                            .replaceAll(',', '')
                        : '',
                    style: GoogleFonts.quicksand(
                        fontSize: 13, color: Colors.grey)),*/
              ],
            )),
        Expanded(
          child: SizedBox(
            height: 55,
            child: ListView.separated(
              padding: const EdgeInsets.only(right: 25),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index2) {
                List<String> opcionesMap =
                    opcion.listado.map((e) => e.tipo).toList();

                final opcionIndex = opcion.listado[index2];
                return OpcionWidget(
                  index: index,
                  opcionIndex: opcionIndex,
                  listadoOpciones: opcionesMap,
                  maximo: opcion.maximo,
                  minimo: opcion.minimo,
                );
              },
              itemCount: opcion.listado.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                width: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OpcionWidget extends StatefulWidget {
  const OpcionWidget({
    Key? key,
    required this.index,
    required this.opcionIndex,
    required this.listadoOpciones,
    required this.maximo,
    required this.minimo,
  }) : super(key: key);

  final List<String> listadoOpciones;
  final int index;
  final Listado opcionIndex;
  final int maximo;
  final int minimo;

  @override
  State<OpcionWidget> createState() => _OpcionWidgetState();
}

class _OpcionWidgetState extends State<OpcionWidget> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthService>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      if (widget.opcionIndex.auto) {
        provider.modificarListadoTemp(
            opcion: widget.opcionIndex.tipo,
            index: widget.index,
            permitido: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return GestureDetector(
      onTap: authService.listadoTemp
                  .indexWhere((element) => element.index == widget.index) !=
              -1
          ? authService
                  .listadoTemp[authService.listadoTemp
                      .indexWhere((element) => element.index == widget.index)]
                  .listado
                  .contains(widget.opcionIndex.tipo)
              ? (() {
                  authService.eliminarOpcionExtraMisma(
                      index: widget.index, opcion: widget.opcionIndex.tipo);
                })
              : (() async {
                  var check = await calcularRepetidos(
                      maximo: widget.maximo,
                      minimo: widget.minimo,
                      index: widget.index,
                      opciones: widget.listadoOpciones,
                      listadoTemp: authService.listadoTemp);

                  authService.modificarListadoTemp(
                    opcion: widget.opcionIndex.tipo,
                    index: widget.index,
                    permitido: check,
                  );
                })
          : (() async {
              var check = await calcularRepetidos(
                  maximo: widget.maximo,
                  minimo: widget.minimo,
                  index: widget.index,
                  opciones: widget.listadoOpciones,
                  listadoTemp: authService.listadoTemp);

              authService.modificarListadoTemp(
                opcion: widget.opcionIndex.tipo,
                index: widget.index,
                permitido: check,
              );
            }),
      child: Stack(
        children: [
          AnimatedContainer(
              margin: const EdgeInsets.only(right: 10, bottom: 7),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              decoration: BoxDecoration(
                  color: authService.listadoTemp.indexWhere((element) => element.index == widget.index) !=
                          -1
                      ? authService
                              .listadoTemp[authService.listadoTemp.indexWhere(
                                  (element) => element.index == widget.index)]
                              .listado
                              .contains(widget.opcionIndex.tipo)
                          ? const Color.fromRGBO(62, 204, 191, 1)
                          : const Color.fromRGBO(200, 201, 203, .2)
                      : const Color.fromRGBO(200, 201, 203, .2),
                  borderRadius: BorderRadius.circular(25)),
              duration: const Duration(milliseconds: 300),
              child: Center(
                  child: Text(widget.opcionIndex.tipo,
                      style: GoogleFonts.quicksand(
                          color: authService.listadoTemp.indexWhere((element) =>
                                      element.index == widget.index) !=
                                  -1
                              ? authService
                                      .listadoTemp[authService.listadoTemp
                                          .indexWhere((element) => element.index == widget.index)]
                                      .listado
                                      .contains(widget.opcionIndex.tipo)
                                  ? Colors.white
                                  : Colors.grey
                              : Colors.grey)))),
          Positioned(
            bottom: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.opcionIndex.fijo
                  ? 1
                  : widget.opcionIndex.precio > 0
                      ? mostrarExtras(
                              maximo: widget.maximo,
                              minimo: widget.minimo,
                              index: widget.index,
                              opciones: widget.listadoOpciones,
                              listadoTemp: authService.listadoTemp)
                          ? authService
                                      .listadoTemp[authService.listadoTemp
                                          .indexWhere((element) =>
                                              element.index == widget.index)]
                                      .listado[0] ==
                                  widget.opcionIndex.tipo
                              ? 0
                              : 1
                          : 0
                      : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  '+ ${widget.opcionIndex.precio.toStringAsFixed(2)}',
                  style:
                      GoogleFonts.quicksand(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> calcularRepetidos(
      {required int maximo,
      required int minimo,
      required int index,
      required List<String> opciones,
      required List<ListadoOpcionesTemp> listadoTemp}) async {
    var check = opciones.map((e) {
      if (listadoTemp.indexWhere((element) => element.index == index) != -1) {
        if (listadoTemp[
                listadoTemp.indexWhere((element) => element.index == index)]
            .listado
            .contains(e)) {
          return 1;
        } else {
          return 0;
        }
      }
      return 0;
    });

    int resum = check.reduce((value, element) => value + element);

    return resum >= maximo ? true : false;
  }

  bool mostrarExtras(
      {required int maximo,
      required int minimo,
      required int index,
      required List<String> opciones,
      required List<ListadoOpcionesTemp> listadoTemp}) {
    var check = opciones.map((e) {
      if (listadoTemp.indexWhere((element) => element.index == index) != -1) {
        if (listadoTemp[
                listadoTemp.indexWhere((element) => element.index == index)]
            .listado
            .contains(e)) {
          return 1;
        } else {
          return 0;
        }
      }
      return 0;
    });

    int resum = check.reduce((value, element) => value + element);

    return resum < minimo ? false : true;
  }
}
