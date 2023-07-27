import 'dart:convert';
import 'dart:io';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/helpers/haversine.dart';
import 'package:delivery/models/cesta.dart';
import 'package:delivery/models/codigo_response.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/direccion.dart' as coordenas;
import 'package:delivery/models/envio_valor.dart';
import 'package:delivery/models/estado_sistema.dart';
import 'package:delivery/models/image_response.dart';
import 'package:delivery/models/lista_opciones.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/promocion.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/usuario.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:delivery/models/auth.dart';
import 'package:delivery/models/errors.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'local_storage.dart';

enum SingingCharacter { lafayette, jefferson, jamon }

enum AuthStatus { checking, authenticated, notAuthenticated }

enum ButtonStatus { autenticando, disponible, pressed }

enum PuntoVenta { isAvailable, notAvailable }

enum EstadoSistema {
  isMaintenance,
  isClosed,
  isOpen,
  isAvailable,
  isNotAvailable,
  noUpdate,
  restringido
}

class AuthService with ChangeNotifier {
  ButtonStatus _buttonStatus = ButtonStatus.disponible;
  ButtonStatus get buttonStatus => _buttonStatus;
  set buttonStatus(ButtonStatus buttonStatus) {
    _buttonStatus = buttonStatus;
    notifyListeners();
  }

  AuthStatus authStatus = AuthStatus.checking;
  PuntoVenta puntoVentaStatus = PuntoVenta.notAvailable;
  EstadoSistema estadoSistemaStatus = EstadoSistema.isOpen;

  late Usuario usuario;

  /////////TABA//////////
  
  SingingCharacter grupo = SingingCharacter.jamon;


  /////////TABA//////////

  List<ListadoOpcionesTemp> listadoTemp = [];

  /*Imagen*/
  late File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
    notifyListeners();
  }

  estadoApartado() {
    usuario.cesta.apartado = usuario.cesta.apartado ? false : true;
    notifyListeners();
  }

  estadoApartado2() {
    usuario.cesta.apartado = false;
  }

  revisarEstado() async {
    final resp = await http.get(
        Uri.parse('${Statics.apiUrl}/autentificacion/revisarEstado'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken(),
          'x-version': '1.0.8 beta'
        });


    final estado = estadoSistemaFromJson(resp.body);

    if (estado.restringido) {
      estadoSistemaStatus = EstadoSistema.restringido;
    } else {
      if (estado.version != 'true') {
        estadoSistemaStatus = EstadoSistema.noUpdate;
      } else {
        if (estado.cerrada) {
          estadoSistemaStatus = EstadoSistema.isClosed;
        } else if (estado.mantenimiento) {
          estadoSistemaStatus = EstadoSistema.isMaintenance;
        } else if (estado.disponible) {
          estadoSistemaStatus = EstadoSistema.isAvailable;
        } else {
          estadoSistemaStatus = EstadoSistema.isNotAvailable;
        }
      }
    }
  }



  calcularPromociones(
      {required List<Promocion> promociones,
      required Producto producto,
      bool eliminar = false}) async {
    if (usuario.cesta.productos.isNotEmpty) {
      final index =
          promociones.indexWhere((element) => element.sku == producto.sku);

      if (index != -1) {
        if (producto.cantidad >= promociones[index].cantidad) {
          final alcance = producto.cantidad ~/ promociones[index].cantidad;

          var enCesta =
              productoAgregado2(id: '${producto.id}promo', opciones: []);

          if (enCesta!.isNotEmpty) {
            int index = usuario.cesta.productos
                .indexWhere((element) => element.sku == enCesta);

            final data = {
              'id': usuario.cesta.productos[index].id,
              'cantidad': usuario.cesta.productos[index].cantidad + alcance
            };

            try {
              final resp = await http.post(
                  Uri.parse(
                      '${Statics.apiUrl}/usuario/modificarCantidadProductoCesta'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type': 'application/json',
                    'x-token': await AuthService.getToken()
                  });

              if (resp.statusCode == 200) {
                usuario.cesta.productos[index].cantidad = alcance;
                calcularTotal();
                usuario.cesta.productos
                    .sort((a, b) => a.nombre.compareTo(b.nombre));
                vaciarElementosTemp();
                return true;
              } else {
                return false;
              }
            } catch (e) {
              return false;
            }
          } else {
            final Producto newProducto = Producto(
                id: promociones[index].id,
                precio: -promociones[index].descuento,
                nombre: promociones[index].titulo,
                descripcion: '',
                descuentoP: 0,
                descuentoC: 0,
                disponible: true,
                tienda: 'Black Shop',
                cantidad: alcance,
                extra: calcularOpcionesExtra(opciones: []),
                opciones: [],
                sku: '${producto.id}promo',
                imagen: '',
                hot: 0,
                sugerencia: false,
                fechaVenta: DateTime(0000, 00, 00, 00, 00),
                apartado: false);

            newProducto.cantidad = alcance;
            usuario.cesta.productos.insert(0, newProducto);

            try {
              final data = {'producto': newProducto.toJson()};

              final resp = await http.post(
                  Uri.parse('${Statics.apiUrl}/usuario/agregarProductoCesta'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type': 'application/json',
                    'x-token': await AuthService.getToken()
                  });

              if (resp.statusCode == 200) {
                calcularTotal();
                usuario.cesta.productos
                    .sort((a, b) => a.nombre.compareTo(b.nombre));
                vaciarElementosTemp();
                return true;
              } else {
                return false;
              }
            } catch (e) {
              return false;
            }
          }
        } else {
          if (eliminar) {
            final data = {"id": producto.id};

            try {
              final resp = await http.post(
                  Uri.parse('${Statics.apiUrl}/usuario/eliminarProductoCesta'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type': 'application/json',
                    'x-token': await AuthService.getToken()
                  });

              if (resp.statusCode == 200) {
                usuario.cesta.productos.removeWhere(
                    (element) => element.id == promociones[index].id);
                calcularTotal();
                usuario.cesta.productos
                    .sort((a, b) => a.nombre.compareTo(b.nombre));
                notifyListeners();
                return true;
              } else {
                return false;
              }
            } catch (e) {
              return false;
            }
          }
        }
      }
    }
  }

  Future<bool> postProfileImage() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    String fileName = image.path.split('/').last;

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'x-token': await AuthService.getToken()
    };

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');

    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('${Statics.apiUrl}/usuarios/guardarFotoPerfil'));
    imageUploadRequest.headers.addAll(headers);
    imageUploadRequest.files.add(await http.MultipartFile.fromPath(
        'photo', image.path,
        filename: fileName,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));

    try {
      final stremResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(stremResponse);
      final image = imageRespomseFromJson(response.body);
      usuario.profilePhotoKey = image.url;
      await Future.delayed(const Duration(milliseconds: 1500));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  /*Imagen*/

  Future<bool> repartidorOff() async {
    await Future.delayed(const Duration(seconds: 1));

    final data = {'uid': usuario.uid};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/desconectar'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        usuario.onlineRepartidor = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> repartidorOn() async {
    await Future.delayed(const Duration(seconds: 1));

    final data = {'uid': usuario.uid};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/conectar'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        usuario.onlineRepartidor = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> transitoUsuario() async {
    await Future.delayed(const Duration(seconds: 1));

    final data = {'id': usuario.uid};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/transitoUsuario'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        usuario.transito = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> transitoUsuarioOff() async {
    final data = {'id': usuario.uid};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/transitoUsuarioOff'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        usuario.transito = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future register(String nombre, String email, String password, String numero,
      String passwordCheck, String dialCode) async {
    final pushProvider = PushNotificationProvider();
    final tokenFirebase = await pushProvider.firebaseMessaging.getToken();
    buttonStatus = ButtonStatus.autenticando;
    await Future.delayed(const Duration(milliseconds: 500));
    List<Errore> lista = [];
    final String superNumero = numero.replaceAll(RegExp(r' '), '');
    final data = {
      'nombre': nombre,
      'correo': email,
      'tokenFB': tokenFirebase,
      'contrasena': password,
      'confirmar_contrasena': passwordCheck,
      'numero_celular': superNumero,
      'dialCode': dialCode,
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/autentificacion/nuevoUsuario'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token, false, '');
        return lista;
      } else {
        final resErrores = errorResponseFromJson(resp.body);
        lista = resErrores.errores;
        return lista;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future logIn(String email, String password) async {
    buttonStatus = ButtonStatus.autenticando;
    await Future.delayed(const Duration(milliseconds: 500));
    List<Errore> lista = [];
    final data = {'correo': email, 'contrasena': password};
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/autentificacion/iniciarUsuario'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token, false, '');
        return lista;
      } else {
        final resErrores = errorResponseFromJson(resp.body);
        lista = resErrores.errores;
        return lista;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> logInCelular({required String numero}) async {
    final pushProvider = PushNotificationProvider();
    final tokenFirebase = await pushProvider.firebaseMessaging.getToken();
    final data = {
      'numero': numero.replaceAll(' ', ''),
      'tokenFB': tokenFirebase
    };
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/autentificacion/iniciarUsuarioTelefono'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
          });
      print(resp.body);
      if (resp.statusCode == 200) {
        print('que');
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token, false, '');
        await Future.delayed(const Duration(milliseconds: 750));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future iniciarFakeSession() async {
    usuario = Usuario(
        codigo: '',
        online: true,
        direcciones: [],
        correo: 'test@tes.com',
        nombreUsuario: 'Test User',
        nombre: 'Test name',
        socio: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        uid: '',
        negocios: [],
        numeroCelular: '4321098765',
        customerID: '',
        nombreCodigo: 'dasd',
        idCodigo: '',
        dialCode: '',
        repartidor: false,
        ultimaTarea: DateTime.now(),
        onlineRepartidor: false,
        transito: false,
        cesta: Cesta(
            productos: [],
            total: 0,
            tarjeta: '',
            direccion: Direccion(
                id: '',
                predeterminado: false,
                titulo: '',
                coordenadas: coordenas.Coordenadas(lat: 0, lng: 0, id: '')),
            efectivo: false,
            apartado: false,
            codigo: 'dasd'),
        hibrido: false);

    authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(seconds: 1));
    final pushProvider = PushNotificationProvider();
    final tokenFirebase = await pushProvider.firebaseMessaging.getToken();
    try {
      final token = LocalStorage.prefs.getString('token');
      final resp = await http.get(
          Uri.parse('${Statics.apiUrl}/autentificacion/renovarCodigo'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': token ?? '',
            'x-token-firebase': tokenFirebase ?? ''
          });

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);

        usuario = loginResponse.usuario;

        await _guardarToken(
            loginResponse.token, loginResponse.checkToken, tokenFirebase!);
        await Future.delayed(const Duration(milliseconds: 750));

        return true;
      } else {
        logout();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future _guardarToken(String token, bool isSocio, String token2) async {
    await LocalStorage.prefs.setString('token', token);
    await LocalStorage.prefs.setString('token2', token2);
    authStatus = AuthStatus.authenticated;
    buttonStatus = ButtonStatus.disponible;
    if (isSocio) {
      puntoVentaStatus = PuntoVenta.isAvailable;
    }
    await revisarEstado();
    notifyListeners();
  }

  /*Future cambiarDireccionFavorita(String id) async {
    usuario.direccionFavorita = id;
    notifyListeners();
  }*/

  /*Future cambiarTiendaFavorita(String id, int position) async {
    usuario.tiendaFavorita = id;
    notifyListeners();
  }*/

  static Future<String> getToken() async {
    final token = LocalStorage.prefs.getString('token');
    print(token);
    return token!;
  }

  static Future<String> getPuntoVenta() async {
    final token = LocalStorage.prefs.getString('token2');
    return token!;
  }

  Future logout() async {
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
    await LocalStorage.prefs.remove('token');
  }

  Future cambiarMetodoDePago({required int tipo}) async {
    if (tipo == 1) {
      usuario.cesta.efectivo = false;
    } else {
      usuario.cesta.efectivo = true;
    }
    notifyListeners();
  }

  Future<bool> agregarProductoCesta(
      {bool skuOnly = false,
      required Producto producto,
      required num cantidad,
      required List<String> listado,
      required num envio}) async {
    List<Opcion> opciones = producto.opciones
        .map((e) => Opcion(
            titulo: e.titulo,
            listado: e.listado.map((e) {
              return Listado(
                  precio: e.precio,
                  tipo: e.tipo,
                  activo: listado.contains(e.tipo) ? true : false,
                  auto: e.auto,
                  fijo: e.fijo,
                  hot: e.hot);
            }).toList(),
            maximo: e.maximo,
            minimo: e.minimo))
        .toList();

    var enCesta = productoAgregado(id: producto.id, opciones: opciones);

    if (enCesta!.isNotEmpty) {
      int index = usuario.cesta.productos
          .indexWhere((element) => element.sku == enCesta);

      final data = {
        'id': producto.id,
        'cantidad': usuario.cesta.productos[index].cantidad + cantidad > 15
            ? 15
            : usuario.cesta.productos[index].cantidad + cantidad
      };

      try {
        final resp = await http.post(
            Uri.parse(
                '${Statics.apiUrl}/usuario/modificarCantidadProductoCesta'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'x-token': await AuthService.getToken()
            });

        if (resp.statusCode == 200) {
          usuario.cesta.productos[index].cantidad =
              usuario.cesta.productos[index].cantidad + cantidad > 15
                  ? 15
                  : usuario.cesta.productos[index].cantidad + cantidad;
          calcularTotal();
          vaciarElementosTemp();
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      final Producto newProducto = Producto(
          id: producto.id,
          precio: producto.precio,
          nombre: producto.nombre,
          descripcion: producto.descripcion,
          descuentoP: producto.descuentoP,
          descuentoC: producto.descuentoC,
          disponible: producto.disponible,
          tienda: producto.tienda,
          cantidad: cantidad,
          extra: calcularOpcionesExtra(opciones: opciones),
          opciones: opciones,
          sku: skuOnly ? producto.sku : producto.id + listado.toString(),
          imagen: producto.imagen,
          hot: producto.hot,
          sugerencia: false,
          fechaVenta: DateTime(0000, 00, 00, 00, 00),
          apartado: false);

      newProducto.cantidad = cantidad;
      usuario.cesta.productos.insert(0, newProducto);

      try {
        final data = {'producto': newProducto.toJson()};

        final resp = await http.post(
            Uri.parse('${Statics.apiUrl}/usuario/agregarProductoCesta'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'x-token': await AuthService.getToken()
            });

        if (resp.statusCode == 200) {
          calcularTotal();
          vaciarElementosTemp();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }

  String? productoAgregado(
      {required String id, required List<Opcion> opciones}) {
    List<Producto> listaRepetidos =
        usuario.cesta.productos.where((element) => element.id == id).toList();
    if (listaRepetidos.isEmpty) {
      return '';
    } else {
      for (var item in listaRepetidos) {
        if (listEquals(item.opciones, opciones)) {
          return item.sku;
        }
      }
      return '';
    }
  }

  String? productoAgregado2(
      {required String id, required List<Opcion> opciones}) {
    List<Producto> listaRepetidos =
        usuario.cesta.productos.where((element) => element.sku == id).toList();
    if (listaRepetidos.isEmpty) {
      return '';
    } else {
      for (var item in listaRepetidos) {
        if (listEquals(item.opciones, opciones)) {
          return item.sku;
        }
      }
      return '';
    }
  }

  num calcularTotal() {
    var valores = usuario.cesta.productos.fold<num>(
        0,
        (previousValue, element) =>
            (element.cantidad * (element.precio + element.extra)) +
            previousValue);
    return valores == 0 ? 0 : valores;
  }

  num calcularOpcionesExtra({required List<Opcion> opciones}) {
    if (opciones.isEmpty) {
      return 0;
    } else {
      List<int> errorValores = [];
      List<List<String>> listado = [];
      for (var element in listadoTemp) {
        listado.add(element.listado);
      }

      for (var i = 0; i < listado.length; i++) {
        if (listado[i].length >= opciones[i].minimo) {
          errorValores.add(i);
        } else {
          errorValores.removeWhere((element) => element == i);
        }
      }

      var listaExpanded = listado.expand((x) => x).toList();

      var listaMap = opciones.map((e) => e.listado
          .map((e2) => listaExpanded.contains(e2.tipo) ? e2.precio : 0));

      var listadoMapExpanded = listaMap.expand((x) => x).toList();

      for (var element in errorValores) {
        listadoMapExpanded.add(
            (opciones[element].minimo) * -opciones[element].listado[0].precio);
      }

      var listadpMapReduce =
          listadoMapExpanded.reduce((value, element) => value + element);

      return listadpMapReduce;
    }
  }

  num totalPiezas() {
    var totaltem = usuario.cesta.productos.fold<num>(
        0, (previousValue, element) => element.cantidad + previousValue);
    return totaltem;
  }

  Future<bool> actulizarCantidad(
      {required int cantidad, required int index}) async {
    final data = {
      'id': usuario.cesta.productos[index].id,
      'cantidad': cantidad
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/usuario/modificarCantidadProductoCesta'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        usuario.cesta.productos[index].cantidad = cantidad;

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarProductoCesta({required int pos}) async {
    final data = {"id": usuario.cesta.productos[pos].id};
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/usuario/eliminarProductoCesta'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        usuario.cesta.productos.removeAt(pos);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarCesta() async {
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/usuario/eliminarCestaProductos'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        usuario.cesta.productos = [];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool cambiarTarjetaCesta(
      {required String id, required String tarjetaPredeterminada}) {
    if (tarjetaPredeterminada.isEmpty) {
      usuario.cesta.tarjeta = id;
      notifyListeners();
    } else {
      if (tarjetaPredeterminada == id) {
        usuario.cesta.tarjeta = '';
        notifyListeners();
      } else {
        usuario.cesta.tarjeta = id;
        notifyListeners();
      }
    }

    return true;
  }

  bool cambiarDireccionCesta(
      {required Direccion direccion, required List<Direccion> direcciones}) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);

    if (busqueda == -1) {
      var direccionPlus = Direccion(
          id: direccion.id,
          coordenadas: direccion.coordenadas,
          predeterminado: direccion.predeterminado,
          titulo: direccion.titulo);

      usuario.cesta.direccion = direccionPlus;
      notifyListeners();
    } else {
      if (direccion.id == direcciones[busqueda].id) {
        usuario.cesta.direccion.titulo = '';
        notifyListeners();
      } else {
        var direccionPlus = Direccion(
            id: direccion.id,
            coordenadas: direccion.coordenadas,
            predeterminado: direccion.predeterminado,
            titulo: direccion.titulo);

        usuario.cesta.direccion = direccionPlus;
        notifyListeners();
      }
    }

    return true;
  }

  eliminarOpcionExtraMisma({required int index, required String opcion}) {
    listadoTemp[listadoTemp.indexWhere((element) => element.index == index)]
        .listado
        .removeWhere((element) => element == opcion);
    notifyListeners();
  }

  modificarListadoTemp({
    required String opcion,
    required int index,
    required bool permitido,
  }) {
    if (listadoTemp.indexWhere((element) => element.index == index) != -1) {
      if (permitido) {
        listadoTemp[listadoTemp.indexWhere((element) => element.index == index)]
            .listado
            .removeAt(0);
        listadoTemp[listadoTemp.indexWhere((element) => element.index == index)]
            .listado
            .add(opcion);
        notifyListeners();
      } else {
        listadoTemp[listadoTemp.indexWhere((element) => element.index == index)]
            .listado
            .add(opcion);
        notifyListeners();
      }
    } else {
      final listado = [opcion];
      final opcionNueva = ListadoOpcionesTemp(index: index, listado: listado);
      listadoTemp.add(opcionNueva);
      notifyListeners();
    }
  }

  vaciarElementosTemp() {
    listadoTemp = [];
    notifyListeners();
  }

  Future<Venta?> crearPedido(
      {required bool tiendaRopa,
      required List<EnvioValor> listadoEnviosValores,
      bool apartado = false,
      bool liquidado = false,
      String abono = '0',
      required num envio,
      required Direccion direccion,
      String tarjeta = '',
      required String customer}) async {


        //quitar los apartadis de teba en las propiedades de codigo y
    Cesta cestaEnvio = Cesta(
        productos: usuario.cesta.productos,
        total: calcularTotal() +
             calcularTotalPropina(),
        tarjeta: tarjeta,
        direccion: direccion,
        efectivo: usuario.cesta.efectivo,
        codigo: usuario.cesta.codigo,
        apartado: usuario.cesta.apartado);
    String precio = abono.replaceAll('\$', '');
    precio = precio.replaceAll(' ', '');
    precio = precio.replaceAll(',', '');
    precio = precio.replaceAll(',', '');
    final data = {
      'abonoReq': precio,
      'servicio': (5.6 * calcularTiendas()),
      'envio': envio,
      'usuario': usuario.uid,
      'customer': customer,
      'cesta': cestaToJson(cestaEnvio),
      'tienda_ropa': tiendaRopa,
      'apartado': apartado,
      'liquidado': liquidado,
      'envioValores': jsonEncode(listadoEnviosValores)
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/crearPedido'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken(),
            'x-version': '1.0.6 beta'
          });

      var respJson = ventoFromJson(resp.body);

      //////taba//////
      grupo = SingingCharacter.jamon;
      notifyListeners();

      if (resp.statusCode == 200) {
        usuario.cesta.productos = [];
        usuario.cesta.codigo = '';
        if (!tiendaRopa) {
          notifyListeners();
        }
        return respJson;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  modificarGrupo({ SingingCharacter grupoS  = SingingCharacter.jamon}){

    if(grupoS == grupo){
      grupo = SingingCharacter.jamon;
      notifyListeners();
    }else{
      grupo = grupoS;
      notifyListeners();
    }
  }

 num calcularTotalPropina(){

    if(grupo == SingingCharacter.jamon){
      return 0;
    }else if(grupo == SingingCharacter.lafayette){
      return (calcularTotal()/100)*10;
    }else{
      return (calcularTotal()/100)*15;
    }

  }

  Future<Venta?> crearPedido2(
      {required bool tiendaRopa,
      bool apartado = false,
      bool liquidado = false,
      required num envio,
      required Direccion direccion,
      String tarjeta = '',
      required String customer}) async {
    Cesta cestaEnvio = Cesta(
        productos: usuario.cesta.productos,
        total: -(usuario.cesta.codigo != '' ? envio : 0) +
            calcularTotal() +
            (5.6 * calcularTiendas()) +
            envio,
        tarjeta: tarjeta,
        direccion: direccion,
        efectivo: usuario.cesta.efectivo,
        codigo: usuario.cesta.codigo,
        apartado: usuario.cesta.apartado);
    final data = {
      'servicio': (5.6 * calcularTiendas()),
      'envio': envio,
      'usuario': usuario.uid,
      'customer': customer,
      'cesta': cestaToJson(cestaEnvio),
      'tienda_ropa': tiendaRopa,
      'apartado': apartado,
      'liquidado': liquidado
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/crearPedido'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      var respJson = ventoFromJson(resp.body);

      if (resp.statusCode == 200) {
        usuario.cesta.productos = [];
        usuario.cesta.codigo = '';
        return respJson;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  calcularTiendas() {
    List<String> listado = [];
    for (var element in usuario.cesta.productos) {
      if (listado.contains(element.tienda)) {
      } else {
        listado.add(element.tienda);
      }
    }
    return listado.length;
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }

  List<EnvioValor> calcularEnviosIndividuales(
      {required List<Tienda> tiendas,
      required,
      required List<Direccion> direcciones}) {
    List<Tienda> listado = [];
    List<String> listado2 = [];

    List<EnvioValor> valores = [];

    for (var element1 in usuario.cesta.productos) {
      if (!listado2.contains(element1.tienda)) {
        listado.add(
            tiendas.firstWhere((element) => element.nombre == element1.tienda));
      }
    }

    for (var element in listado) {
      var distancia = calculateDistance(
          lat1: element.coordenadas.latitud,
          lon1: element.coordenadas.longitud,
          lat2: direcciones[usuario.cesta.direccion.titulo != ''
                  ? direcciones.indexWhere((element) =>
                      usuario.cesta.direccion.titulo == element.titulo)
                  : obtenerFavorito(direcciones) != -1
                      ? obtenerFavorito(direcciones)
                      : 0]
              .coordenadas
              .lat,
          lon2: direcciones[usuario.cesta.direccion.titulo != ''
                  ? direcciones.indexWhere((element) =>
                      usuario.cesta.direccion.titulo == element.titulo)
                  : obtenerFavorito(direcciones) != -1
                      ? obtenerFavorito(direcciones)
                      : 0]
              .coordenadas
              .lng);

      var pre = EnvioValor(
          cantidad: (distancia <= 3 ? 29.7 : ((distancia - 3) * 12.3) + 29.7),
          tienda: element.nombre);

      valores.add(pre);
    }

    return valores;
  }

  num calcularEnvioAvanzado(
      {required List<Tienda> tiendas,
      required,
      required List<Direccion> direcciones}) {
    List<Tienda> listado = [];
    List<String> listado2 = [];
    List<num> distancias = [];

    for (var element1 in usuario.cesta.productos) {
      if (!listado2.contains(element1.tienda)) {
        listado.add(
            tiendas.firstWhere((element) => element.nombre == element1.tienda));
      }
    }

    for (var element in listado) {
      distancias.add(calculateDistance(
          lat1: element.coordenadas.latitud,
          lon1: element.coordenadas.longitud,
          lat2: direcciones[usuario.cesta.direccion.titulo != ''
                  ? direcciones.indexWhere((element) =>
                      usuario.cesta.direccion.titulo == element.titulo)
                  : obtenerFavorito(direcciones) != -1
                      ? obtenerFavorito(direcciones)
                      : 0]
              .coordenadas
              .lat,
          lon2: direcciones[usuario.cesta.direccion.titulo != ''
                  ? direcciones.indexWhere((element) =>
                      usuario.cesta.direccion.titulo == element.titulo)
                  : obtenerFavorito(direcciones) != -1
                      ? obtenerFavorito(direcciones)
                      : 0]
              .coordenadas
              .lng));
    }
    var reduceTotal =
        distancias.map((e) => (e <= 3 ? 29.7 : ((e - 3) * 12.3) + 29.7));

    return reduceTotal.reduce((value, element) => value + element);
  }

  List<String> calcularTiendasNombres() {
    List<String> listado = [];
    for (var element in usuario.cesta.productos) {
      if (listado.contains(element.tienda)) {
      } else {
        listado.add(element.tienda);
      }
    }
    return listado;
  }

  eliminarCupon() {
    usuario.cesta.codigo = '';
    notifyListeners();
  }

  Future<bool> hibridoOff() async {
    final data = {"_id": usuario.uid};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/hibridoOff'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        usuario.hibrido = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> hibridoOn() async {
    final data = {"_id": usuario.uid};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/hibridoOn'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        usuario.hibrido = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<CodigoResponse> aplicarCupon({required String codigo}) async {
    await Future.delayed(const Duration(seconds: 1));

    final data = {"codigo": codigo.toUpperCase()};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/usuario/buscarCodigo'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      var respJson = codigoResponseFromJson(resp.body);

      if (respJson.ok) {
        usuario.cesta.codigo = codigo;
        usuario.nombreCodigo = respJson.usuario;
        usuario.idCodigo = respJson.id;

        notifyListeners();
        return respJson;
      } else {
        return respJson;
      }
    } catch (e) {
      return CodigoResponse(ok: false, usuario: '', id: '', msg: '');
    }
  }
}
