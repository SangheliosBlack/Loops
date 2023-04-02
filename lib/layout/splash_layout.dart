import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashLayout extends StatefulWidget {
  const SplashLayout({Key? key}) : super(key: key);

  @override
  State<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends State<SplashLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: checkLoginState(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 50),
                  //     child: const Image(
                  //         image:
                  //             AssetImage('assets/images/logo_black_shop.jpg'))),
                   CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final isAutenticado = await authService.isLoggedIn();

    if (isAutenticado) {
      socketService.connect();
    }
  }
}
