import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfiguracionVentaView extends StatelessWidget {
  const ConfiguracionVentaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);
    final socioService = Provider.of<SocioService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Configuracion impresora',
          style: GoogleFonts.quicksand(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromRGBO(41, 199, 184, .05)),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Autoimpresion',
                  style: GoogleFonts.quicksand(fontSize: 18),
                ),
                Switch(
                  activeColor: const Color.fromRGBO(41, 199, 184, 1),
                  value: socioService.tienda.autoImpresion,
                  onChanged: (value) {
                    socioService.autoImpresionStatus(
                        status: value, id: socioService.tienda.uid);
                  },
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Divider(
                color: Colors.grey.withOpacity(.2),
              )),
          bluetoothProvider.isConnected
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Impresora conectada',
                            style: GoogleFonts.quicksand(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 25),
                                  child: const Icon(
                                    Icons.print,
                                    color: Colors.blueGrey,
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bluetoothProvider.printerDevice.name ?? '',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 19,
                                        color: const Color.fromRGBO(
                                            41, 199, 184, 1)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      bluetoothProvider.printerDevice.address ??
                                          '',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 14, color: Colors.grey))
                                ],
                              )
                            ],
                          ),
                          const Icon(
                            Icons.signal_cellular_alt,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dispositivos disponibles',
                            style: GoogleFonts.quicksand(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream:
                          bluetoothProvider.printerBluetoothManager.scanResults,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PrinterBluetooth>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              var device = snapshot.data![index];

                              return GestureDetector(
                                onTap: () {
                                  bluetoothProvider.printerBluetoothManager
                                      .selectPrinter(device);
                                  bluetoothProvider.conectarImpresora(
                                      printer: device);

                                  socioService.macChange(
                                      mac: device.address ?? '',
                                      id: socioService.tienda.uid);

                                  Navigator.pop(context);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(right: 25),
                                          child: const Icon(Icons.devices)),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            device.name ?? '',
                                            style: GoogleFonts.quicksand(
                                                fontSize: 19),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(device.address ?? '',
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 14,
                                                  color: Colors.grey))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
