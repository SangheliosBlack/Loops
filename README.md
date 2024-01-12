<a href="https://flutter.dev/">
  <h1 align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png">
      <img alt="Flutter" src="https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png">
    </picture>
  </h1>
</a>

# Loops

Bienvenido a la plantilla Flutter, una base sólida para construir aplicaciones sorprendentes con Flutter. Esta plantilla está diseñada para proporcionar una estructura organizada y eficiente para el desarrollo de aplicaciones móviles, permitiéndote centrarte en la creación de características innovadoras y una experiencia de usuario excepcional.

![Version](https://img.shields.io/badge/Version-1.0.0-00d679?style=for-the-badge&logo=V)
![Stripe](https://img.shields.io/badge/Stripe-7455E8?style=for-the-badge&logo=Stripe&logoColor=white)
![Socket.io](https://img.shields.io/badge/Socket.io-000000?style=for-the-badge&logo=Socket.io&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-4887E7?style=for-the-badge&logo=Firebase&logoColor=F4D208)
![Gitlab](https://img.shields.io/badge/Gitlab-FFFFFF?style=for-the-badge&logo=Gitlab&logoColor=#D74A2C)
![Mockito](https://img.shields.io/badge/Mockito-DBDFFF?style=for-the-badge&logo=Dart&logoColor=black)

## Descripción

Esta aplicación Flutter es mucho más que un simple punto de partida. Es un ecosistema completo que combina las mejores prácticas de desarrollo, herramientas de vanguardia y una selección de dependencias poderosas para acelerar tu proceso de desarrollo.

Con un diseño extensible y modular, esta plantilla te ofrece la flexibilidad necesaria para adaptarse a cualquier tipo de proyecto. Ya sea que estés construyendo una aplicación de comercio electrónico, una aplicación de productividad o una innovadora aplicación de medios, esta plantilla proporciona una base sólida que puedes personalizar y ampliar según tus necesidades específicas.

## Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración](#configuración)
- [Uso](#uso)
- [Pruebas unitarias](#pruebas-unitarias)
- [Características](#características)
- [Contribución](#contribución)
- [Licencia](#licencia)

## Requisitos Previos

- Dart SDK y Flutter SDK instalados
- Otros requisitos específicos...

## Instalación

1. **Clona este repositorio :**
   ```bash
   git clone https://github.com/SangheliosBlack/Flutter-Template.git

2. **Instala las dependencias :**
    ```bash
    flutter pub get

3. **Configuracion de Variables de Entorno**
   - Crea un archivo .env en el directorio raíz.
   - Sigue el formato especificado env.example.

4. **Inicia la aplicacion :**
    ```bash
    flutter run

## Estructura del Proyecto

El proyecto sigue una estructura organizada para facilitar la comprensión y mantenimiento del código. A continuación, se detalla la estructura del proyecto:

- **/lib:** Contiene el código fuente de la aplicación Flutter.
  - `/blocs`: Lógica de negocio y gestión del estado utilizando BLoC.
  - `/helpers`: Funciones y utilidades auxiliares.
  - `/routes`: Configuración de las rutas de la aplicación.
  - `/services`: Lógica de servicios y comunicación con API.
  - `/themes`: Configuración de temas y estilos.
  - `/utils`: Utilidades generales.

## Configuración

Instrucciones sobre cómo configurar el servidor, incluyendo variables de entorno y otros ajustes necesarios.

## Uso
Detalles sobre cómo usar el servidor, ejemplos de llamadas a la API, y cualquier otra información relevante.

## Pruebas Unitarias

En el directorio `test`, encontrarás las siguientes pruebas unitarias:

| Archivo                        |
| ------------------------------ |
| test                           |
| ├── business_logic_test.dart   |
| ├── utility_functions_test.dart|
| ├── external_services_test.dart|
| ├── state_management_test.dart |
| ├── ui_widgets_test.dart        |
| ├── navigation_test.dart        |
| ├── error_handling_test.dart    |
| ├── performance_test.dart       |
| ├── data_persistence_test.dart  |
| └── ui_update_test.dart         |

# Características

El proyecto cuenta con las siguientes características, gracias a las dependencias utilizadas:

- **[flutter_launcher_icons (^0.13.1)](https://pub.dev/packages/flutter_launcher_icons):** Permite personalizar los íconos de la aplicación para las plataformas Android e iOS.

- **[liquid_pull_to_refresh (^3.0.1)](https://pub.dev/packages/liquid_pull_to_refresh):** Proporciona un widget de arrastre para actualizar similar a un líquido.

- **[expandable_page_view (^1.0.17)](https://pub.dev/packages/expandable_page_view):** Ofrece una vista de página que se puede expandir para proporcionar una experiencia de usuario más dinámica.

- **[curved_navigation_bar (^1.0.3)](https://pub.dev/packages/curved_navigation_bar):** Implementa una barra de navegación inferior curvada para una navegación más atractiva.

- **[font_awesome_flutter (^10.5.0)](https://pub.dev/packages/font_awesome_flutter):** Ofrece acceso a la biblioteca de iconos Font Awesome en Flutter.

- **[shared_preferences (^2.2.0)](https://pub.dev/packages/shared_preferences):** Facilita el almacenamiento persistente de pequeñas cantidades de datos clave-valor en la aplicación.

- **[flutter_stripe (^9.5.0+1)](https://pub.dev/packages/flutter_stripe):** Permite la integración de pagos con la plataforma de Stripe.

- **[flutter_dotenv (^5.1.0)](https://pub.dev/packages/flutter_dotenv):** Carga variables de entorno desde un archivo `.env` para la configuración de la aplicación.

- **[fluttertoast (^8.2.2)](https://pub.dev/packages/fluttertoast):** Proporciona notificaciones Toast en la aplicación.

- **[flutter_bloc (^8.1.3)](https://pub.dev/packages/flutter_bloc):** Implementa el patrón de estado BLoC para gestionar el estado de la aplicación de manera eficiente.

- **[google_fonts (^5.1.0)](https://pub.dev/packages/google_fonts):** Permite el uso de fuentes personalizadas de Google Fonts en la aplicación.

- **[flutter_svg (^2.0.7)](https://pub.dev/packages/flutter_svg):** Facilita la renderización de imágenes SVG en Flutter.

- **[local_auth (^2.1.7)](https://pub.dev/packages/local_auth):** Brinda soporte para la autenticación biométrica y de huellas dactilares.

- **[auto_route (^7.8.0)](https://pub.dev/packages/auto_route):** Simplifica la configuración de rutas de navegación en Flutter.

- **[animate_do (^3.1.2)](https://pub.dev/packages/animate_do):** Proporciona animaciones atractivas para los elementos de la interfaz de usuario.

- **[ansicolor (^2.0.2)](https://pub.dev/packages/ansicolor):** Permite la colorización de la salida en la consola para una mejor legibilidad de los logs.

- **[equatable (^2.0.5)](https://pub.dev/packages/equatable):** Facilita la comparación y copia de objetos de manera eficiente.

- **[hidable (^1.0.5)](https://pub.dev/packages/hidable):** Permite ocultar y mostrar elementos de la interfaz de usuario de manera dinámica.

- **[logging (^1.2.0)](https://pub.dev/packages/logging):** Proporciona una infraestructura de registro para la aplicación.

- **[get_it (^7.6.0)](https://pub.dev/packages/get_it):** Un contenedor de servicios para la inyección de dependencias.

- **[http (^1.1.0)](https://pub.dev/packages/http):** Proporciona funcionalidades HTTP para realizar solicitudes y recibir respuestas.

- **[mockito (^5.0.15)](https://pub.dev/packages/mockito):** Permite la creación de objetos de imitación para realizar pruebas de manera controlada.

# Dependencias de Desarrollo

- **[auto_route_generator (^7.2.0)](https://pub.dev/packages/auto_route_generator):** Genera código para la navegación declarativa.

- **[flutter_lints (^2.0.0)](https://pub.dev/packages/flutter_lints):** Conjunto de reglas y configuraciones de linter para proyectos Flutter.

- **[build_runner (^2.4.5)](https://pub.dev/packages/build_runner):** Automatiza la generación de código en tiempo de compilación.

- **[flutter_test](https://pub.dev/packages/flutter_test):** Proporciona herramientas para escribir y ejecutar pruebas en proyectos Flutter.

# Contribución

Si deseas contribuir a este proyecto, sigue estos pasos:

1. Haz un fork del repositorio.
2. Crea una nueva rama (`git checkout -b feature/nueva-funcionalidad`).
3. Realiza tus cambios y haz commit (`git commit -am 'Agregando nueva funcionalidad'`).
4. Haz push a la rama (`git push origin feature/nueva-funcionalidad`).
5. Crea un Pull Request.

## Contribuidores

[![Julio Villagrana](https://avatars.githubusercontent.com/u/50421116?s=96&v=4)](https://github.com/SangheliosBlack)

# Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.