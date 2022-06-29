import 'package:delivery/firebase_options.dart';
import 'package:delivery/global/enviroment.dart';
import 'package:delivery/layout/auth_layout.dart';
import 'package:delivery/layout/dashboard_layout.dart';
import 'package:delivery/layout/permission_layout.dart';
import 'package:delivery/layout/socio_layout.dart';
import 'package:delivery/layout/splash_layout.dart';
import 'package:delivery/providers/login_form_provider.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:delivery/providers/register_form_provider.dart';
import 'package:delivery/routes/router.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/local_storage.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/puto_dial.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: kIsWeb
          ? DefaultFirebaseOptions.web
          : DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'general_id', // id
      'General', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the

    /// Update the iOS foreground notification presentation options tzsao allow
    /// heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  await LocalStorage.configurePrefs();
  Flurorouter.configureRoutes();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*new StripeService()..init();*/
    return MultiProvider(providers: [
      ChangeNotifierProvider(lazy: false, create: (_) => SocketService()),
      ChangeNotifierProvider(
          lazy: false, create: (_) => RegisterFromProvider()),
      ChangeNotifierProvider(lazy: false, create: (_) => LoginFromProvider()),
      ChangeNotifierProvider(lazy: false, create: (_) => AuthService()),
      ChangeNotifierProvider(lazy: false, create: (_) => PutoDial()),
      ChangeNotifierProvider(
          lazy: false, create: (_) => PermissionStatusProvider()),
    ], child: const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    final pushProvider = PushNotificationProvider();
    pushProvider.initNotifications();

    pushProvider.mensajes.listen((event) {
      navigationService.navigatorKey.currentState!
          .pushNamed('/extras/notificacionPedido', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFff3232, Statics.color);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: navigationService.navigatorKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('es')],
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.white,
          ),
          primarySwatch: colorCustom,
          primaryColor: const Color.fromRGBO(40, 40, 40, 1)),
      initialRoute: Flurorouter.rootRoute,
      onGenerateRoute: Flurorouter.router.generator,
      builder: (_, child) {
        final authProvider = Provider.of<AuthService>(context);
        final socketProvider = Provider.of<SocketService>(context);
        final permissionProvider =
            Provider.of<PermissionStatusProvider>(context);

        return Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) {
              return authProvider.authStatus == AuthStatus.checking
                  ? const SplashLayout()
                  : authProvider.authStatus == AuthStatus.authenticated
                      ? permissionProvider.isGranted &&
                                  permissionProvider.isEnabled ||
                              kIsWeb
                          ? authProvider.puntoVentaStatus ==
                                  PuntoVenta.isAvailable
                              ? SocioLayout(
                                  child: child!,
                                )
                              : socketProvider.serverStatus ==
                                      ServerStatus.Online
                                  ? DashboardLayout(child: child!)
                                  : const SplashLayout()
                          : PermissionLaoyut(child: child!)
                      : AuthLayout(child: child!);
            })
          ],
        );
      },
    );
  }
}
