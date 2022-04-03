import 'package:delivery/global/enviroment.dart';
import 'package:delivery/layout/auth_layout.dart';
import 'package:delivery/layout/dashboard_layout.dart';
import 'package:delivery/layout/permission_layout.dart';
import 'package:delivery/layout/splash_layout.dart';
import 'package:delivery/providers/login_form_provider.dart';
import 'package:delivery/providers/register_form_provider.dart';
import 'package:delivery/routes/router.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/local_storage.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
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
      ChangeNotifierProvider(
          lazy: false, create: (_) => RegisterFromProvider()),
      ChangeNotifierProvider(lazy: false, create: (_) => LoginFromProvider()),
      ChangeNotifierProvider(lazy: false, create: (_) => AuthService()),
      
      ChangeNotifierProvider(
          lazy: false, create: (_) => PermissionStatusProvider()),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
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
        final permissionProvider =
            Provider.of<PermissionStatusProvider>(context);

        return Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) {
              return authProvider.authStatus == AuthStatus.checking
                  ? const SplashLayout()
                  : authProvider.authStatus == AuthStatus.authenticated
                      ? permissionProvider.isGranted &&
                              permissionProvider.isEnabled
                          ? DashboardLayout(child: child!)
                          : PermissionLaoyut(child: child!)
                      : AuthLayout(child: child!);
            })
          ],
        );
      },
    );
  }
}
