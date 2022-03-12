
import 'package:flutter/material.dart';

class _DrawerAction {
   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void openDraw() {
    return scaffoldKey.currentState?.openDrawer();
  }
  void closeDraw() {
    return scaffoldKey.currentState?.openEndDrawer();
  }
}

final drawerAction = _DrawerAction();
