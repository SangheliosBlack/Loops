import 'package:delivery/routes/admin_handlers.dart';
import 'package:delivery/routes/dashboard_handlers.dart';
import 'package:delivery/routes/drawer_handlers.dart';
import 'package:delivery/routes/extras.dart';
import 'package:delivery/routes/no_page_found_hanlders.dart';
import 'package:fluro/fluro.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';

  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register/:numero';

  static String autentificarRoute = '/phone/confirmar';
  static String confirmarRoute = '/phone/confirmar/:numero';

  static String metodosPagoRoute = '/drawer/metodosPago';
  static String direccionesRoute = '/drawer/direcciones';
  static String pedidosRoute = '/drawer/pedidos';
  static String infoVentaRoute = '/drawer/pedidos';
  static String infoRoute = '/drawer/info';
  static String configuracionRoute = '/drawer/settings';

  static String favoritesRoute = '/dashboard/favorites';
  static String orderRoute = '/dashboard/order';
  static String dashboardRoute = '/dashboard';
  static String orderRegisterRoute = '/dashboard/register';
  static String addNewStoreRoute = '/dashboard/addNewStoreRoute';
  static String allowGpsPermissionRoute = '/dashboard/permissionRoute';
  static String addAddressMapRoute = '/dashboard/addAddressMap';

  static String configurarTiendaRoute = '/extras/configurarTienda';
  static String editarMenuRoute = '/extras/editarMenu';
  static String agregarNuevaTiendaRoute = '/extras/agregarNuevaTienda';
  static String editarDireccionesRoute = '/extras/editarDirecciones/:uid';

  static String notificacionPedido = '/extras/notificacionPedido';

  static void configureRoutes() {
    /*DRAWER*/

    router.define(metodosPagoRoute,
        handler: DrawerHandlers.metodosPago,
        transitionDuration: const Duration(milliseconds: 400),
        transitionType: TransitionType.native);
    router.define(direccionesRoute,
        handler: DrawerHandlers.direcciones,
        transitionDuration: const Duration(milliseconds: 400),
        transitionType: TransitionType.native);
    router.define(pedidosRoute,
        transitionDuration: const Duration(milliseconds: 400),
        handler: DrawerHandlers.pedidos,
        transitionType: TransitionType.native);
    router.define(infoVentaRoute,
        transitionDuration: const Duration(milliseconds: 400),
        handler: DrawerHandlers.infoVenta,
        transitionType: TransitionType.native);
    router.define(infoRoute,
        transitionDuration: const Duration(milliseconds: 400),
        handler: DrawerHandlers.info,
        transitionType: TransitionType.native);

    /*DRAWER*/

    router.define(autentificarRoute,
        handler: AdminHandlers.autentificarPhone,
        transitionType: TransitionType.none);
    router.define(confirmarRoute,
        handler: AdminHandlers.confirmarPhone,
        transitionType: TransitionType.none);

    router.define(rootRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);

    router.define(registerRoute,
        handler: AdminHandlers.register, transitionType: TransitionType.none);

    router.define(loginRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);

    router.define(allowGpsPermissionRoute,
        handler: DashBoardHandlers.allowGpsPermission,
        transitionType: TransitionType.none);

    router.define(orderRegisterRoute,
        handler: DashBoardHandlers.orderRegister,
        transitionType: TransitionType.none);

    router.define(dashboardRoute,
        handler: DashBoardHandlers.dashboard,
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: TransitionType.native);

    

    router.define(orderRoute,
        handler: DashBoardHandlers.order,
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: TransitionType.native);

    router.define(favoritesRoute,
        handler: DashBoardHandlers.favorites,
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: TransitionType.native);

    router.define(editarMenuRoute,
        handler: ExtrasHandlers.editarMenu,
        transitionType: TransitionType.cupertinoFullScreenDialog);

    router.define(agregarNuevaTiendaRoute,
        handler: ExtrasHandlers.agregarTienda,
        transitionType: TransitionType.none);

    router.define(notificacionPedido,
        handler: ExtrasHandlers.notificacionPedido,
        transitionType: TransitionType.none);

    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
