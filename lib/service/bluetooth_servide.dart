import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';

class BluetoothProvider with ChangeNotifier {
  late PrinterBluetooth printerDevice;

  final PrinterBluetoothManager printerBluetoothManager =
      PrinterBluetoothManager();

  bool _isGranted = false;

  bool get isGranted => _isGranted;

  set isGranted(bool state) {
    _isGranted = state;

    notifyListeners();
  }

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  set isConnected(bool state) {
    _isConnected = state;
    notifyListeners();
  }

  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  set isEnabled(bool state) {
    _isEnabled = state;
    notifyListeners();
  }

  conectarImpresora({required PrinterBluetooth printer}) {
    _isConnected = true;
    printerDevice = printer;


    notifyListeners();
  }
}
