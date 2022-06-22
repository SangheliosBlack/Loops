import 'package:flutter/material.dart';

class NotificacionPedido extends StatelessWidget {
  const NotificacionPedido({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: Center(child: Text(arg.toString())),
    );
  }
}
