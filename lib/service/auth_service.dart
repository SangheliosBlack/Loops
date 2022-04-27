import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/image_response.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/usuario.dart';
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

class AuthService with ChangeNotifier {
  ButtonStatus _buttonStatus = ButtonStatus.disponible;
  ButtonStatus get buttonStatus => _buttonStatus;
  set buttonStatus(ButtonStatus buttonStatus) {
    _buttonStatus = buttonStatus;
    notifyListeners();
  }

  AuthStatus authStatus = AuthStatus.checking;

  AuthService() {
    isLoggedIn();
  }
  late Usuario usuario;

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

  Future register(String nombre, String email, String password, String numero,
      String passwordCheck) async {
    buttonStatus = ButtonStatus.autenticando;
    await Future.delayed(const Duration(milliseconds: 500));
    List<Errore> lista = [];
    final data = {
      'nombre': nombre,
      'correo': email,
      'contrasena': password,
      'confirmar_contrasena': passwordCheck,
      'numero_celular': numero
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/autentificacion/nuevoUsuario'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
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
        await _guardarToken(loginResponse.token);
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
    final data = {'numero': '52$numero'};
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
        await _guardarToken(loginResponse.token);
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
    final token = LocalStorage.prefs.getString('token');
    final resp = await http.get(
        Uri.parse('${Statics.apiUrl}/autentificacion/renovarCodigo'),
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      await Future.delayed(const Duration(milliseconds: 750));
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    authStatus = AuthStatus.authenticated;
    buttonStatus = ButtonStatus.disponible;
    notifyListeners();
    return LocalStorage.prefs.setString('token', token);
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
      required String eleccion1,
      required String eleccion2}) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Opcion> opciones = producto.opciones
        .map((e) => Opcion(
            titulo: e.titulo,
            listado: e.listado.map((e) {
              return Listado(
                  precio: e.precio,
                  tipo: e.tipo,
                  activo: e.tipo == eleccion1 || e.tipo == eleccion2
                      ? true
                      : false);
            }).toList()))
        .toList();

    var enCesta = productoAgregado(id: producto.id, opciones: opciones);

    if (enCesta!.isNotEmpty) {
      int index = usuario.cesta.productos
          .indexWhere((element) => element.sku == enCesta);
      usuario.cesta.productos[index].cantidad =
          usuario.cesta.productos[index].cantidad + cantidad > 15
              ? 15
              : usuario.cesta.productos[index].cantidad + cantidad;
      notifyListeners();
      return true;
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
          opciones: opciones,
          sku: producto.id + eleccion1 + eleccion2);

      newProducto.cantidad = cantidad;
      usuario.cesta.productos.insert(0, newProducto);

      calcularTotal();
      notifyListeners();
      return true;
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
            (element.cantidad * element.precio) + previousValue);
    return valores == 0 ? 0 : valores;
  }

  num totalPiezas() {
    var totaltem = usuario.cesta.productos.fold<num>(
        0, (previousValue, element) => element.cantidad + previousValue);
    return totaltem;
  }

  void actulizarCantidad({required int cantidad, required int index}) {
    usuario.cesta.productos[index].cantidad = cantidad;
    notifyListeners();
  }

  Future<void> eliminarProductoCesta({required int pos}) async {
    await Future.delayed(const Duration(seconds: 1));

    usuario.cesta.productos.removeAt(pos);
    notifyListeners();
  }
}
