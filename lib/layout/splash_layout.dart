import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: checkLoginState(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return const CircularProgressIndicator();
          },
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
