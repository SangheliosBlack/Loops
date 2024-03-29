import 'package:delivery/service/permission_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PermissionLaoyut extends StatefulWidget {
  final Widget child;

  const PermissionLaoyut({Key? key, required this.child}) : super(key: key);

  @override
  PermissionLaoyutState createState() => PermissionLaoyutState();
}

class PermissionLaoyutState extends State<PermissionLaoyut>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final permissionService =
          Provider.of<PermissionStatusProvider>(context, listen: false);
      permissionService.accesoGPS();
      permissionService.gpsEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: widget.child,
    );
  }
}
