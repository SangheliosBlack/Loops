import 'dart:convert';
import 'dart:io';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/helpers/haversine.dart';
import 'package:delivery/models/cesta.dart';
import 'package:delivery/models/codigo_response.dart';
import 'package:delivery/models/customer.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/image_response.dart';
import 'package:delivery/models/lista_opciones.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/usuario.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:delivery/models/auth.dart';
import 'package:delivery/models/errors.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'local_storage.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

enum ButtonStatus { autenticando, disponible, pressed }

enum PuntoVenta { isAvailable, notAvailable }

class AuthService with ChangeNotifier {
  ButtonStatus _buttonStatus = ButtonStatus.disponible;
  ButtonStatus get buttonStatus => _buttonStatus;
  set buttonStatus(ButtonStatus buttonStatus) {
    _buttonStatus = buttonStatus;
    notifyListeners();
  }

  AuthStatus authStatus = AuthStatus.checking;
  PuntoVenta puntoVentaStatus = PuntoVenta.notAvailable;

  late Usuario usuario;

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
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token, false, '');
        await Future.delayed(const Duration(milliseconds: 750));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
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
      {required Producto producto,
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
          sku: producto.id + listado.toString(),
          imagen: producto.imagen,
          hot: producto.hot,
          sugerencia: false);

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
    await Future.delayed(const Duration(seconds: 1));
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
    await Future.delayed(const Duration(seconds: 1));

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
      {required num envio,
      required Direccion direccion,
      String tarjeta = '',
      required Customer customer}) async {
    Cesta cestaEnvio = Cesta(
        productos: usuario.cesta.productos,
        total: -(usuario.cesta.codigo != '' ? envio : 0) +
            calcularTotal() +
            (10.2 * calcularTiendas()) +
            envio,
        tarjeta: tarjeta,
        direccion: direccion,
        efectivo: usuario.cesta.efectivo,
        codigo: usuario.cesta.codigo);
    final data = {
      'servicio': (10.2 * calcularTiendas()),
      'envio': envio,
      'usuario': usuario.uid,
      'customer': customer.id,
      'cesta': cestaToJson(cestaEnvio)
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

      print(respJson);

      if (resp.statusCode == 200) {
        usuario.cesta.productos = [];
        usuario.cesta.codigo = '';
        notifyListeners();
        return respJson;
      } else {
        print('Object');
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
        distancias.map((e) => (e <= 3 ? 19.8 : ((e - 3) * 7.2) + 19.8));

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
