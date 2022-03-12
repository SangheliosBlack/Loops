import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Statics {
  static String key =
      'pk_test_51IDv5qAJzmt2piZ3NcmMfOsDp6IVNoWsblOcRamMcHDH7froDT4W7F9NoB53grsdvrYLthUL2VA9dYbxEZcOgeqD00Whfvrado';
  static Map<int, Color> color = {
    50: const Color.fromRGBO(255, 255, 255, .1),
    100: const Color.fromRGBO(255, 255, 255, .2),
    200: const Color.fromRGBO(255, 255, 255, .3),
    300: const Color.fromRGBO(255, 255, 255, .4),
    400: const Color.fromRGBO(255, 255, 255, .5),
    500: const Color.fromRGBO(255, 255, 255, .6),
    600: const Color.fromRGBO(255, 255, 255, .7),
    700: const Color.fromRGBO(255, 255, 255, .8),
    800: const Color.fromRGBO(255, 255, 255, .9),
    900: const Color.fromRGBO(255, 255, 255, 1),
  };

  static List<dynamic> listAvatars = [
    {'icono': 58136},
    {'icono': 57627},
    {'icono': 58890},
    {'icono': 57481},
    {'icono': 58280},
    {'icono': 58152},
    {'icono': 58141},
  ];
  static List<dynamic> listPlains = [
    {'icono': Icons.store, 'titulo': 'En linea', 'precio': '100.00'},
    {'icono': Icons.moped, 'titulo': 'En linea 1', 'precio': '150.00'},
    {'icono': Icons.point_of_sale, 'titulo': 'En linea 2', 'precio': '180.00'}
  ];
  static String apiUrl = 'https://server-delivery-production.herokuapp.com/api';
  /*static String apiUrl = 'http://192.168.0.2:3000/api';*/
  static List<dynamic> listSetting = [
    {
      'icono': Icons.credit_card_outlined,
      'titulo': 'Metodos de pago',
      'ruta': '/drawer/metodosPago'
    },
    {
      'icono': Icons.home_outlined,
      'titulo': 'Mis direcciones',
      'ruta': '/drawer/direcciones'
    },
    {
      'icono': Icons.moped_outlined,
      'titulo': 'Mis pedidos',
      'ruta': '/drawer/pedidos'
    },
    {
      'icono': Icons.storefront_outlined,
      'titulo': 'Vender con nosotros',
      'ruta': '/drawer/pedidos'
    },
    {
      'icono': Icons.help_outline,
      'titulo': 'Mas informacion',
      'ruta': '/drawer/info'
    },
    {'icono': Icons.logout, 'titulo': 'Cerrar sesion', 'ruta': 'logout'},
  ];

  static CameraPosition kGooglePlex = const CameraPosition(
      target: LatLng(
        21.3578977,
        -101.9332115,
      ),
      zoom: 15);

  static List<dynamic> listaCategorias = [
    {'titulo': 'Pizza', 'icono': FontAwesomeIcons.pizzaSlice},
    {'titulo': 'Hamburguesas', 'icono': FontAwesomeIcons.hamburger},
    {
      'titulo': 'Saludable',
      'icono': FontAwesomeIcons.seedling,
    },
    {
      'titulo': 'Bebidas',
      'icono': FontAwesomeIcons.beer,
    },
    {
      'titulo': 'Mariscos',
      'icono': FontAwesomeIcons.fish,
    },
  ];
  static String mapStyle = '''
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
  ''';
}
