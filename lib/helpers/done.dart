// ignore_for_file: sized_box_for_whitespace

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void done(BuildContext context, Venta venta) {
  String formattedDate = DateFormat.yMMMEd('es-MX').format(venta.createdAt);
  if (Platform.isAndroid) {
    showDialog(
        barrierColor: Colors.white,
        barrierDismissible: true,
        useSafeArea: true,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 90,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const SizedBox(
                                width: 60,
                                height: 60,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                      'https://scontent.fagu2-1.fna.fbcdn.net/v/t39.30808-6/275180868_124297173499762_436752895256451572_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeHcIPYR4SKCvdFVRkyxM0SsTKRSebkupcRMpFJ5uS6lxNktuu8xuNXualVHBgWiQd-YXd0MNSV1l-ElfW8JlOxv&_nc_ohc=yLVGhinqU88AX8NKpHw&_nc_ht=scontent.fagu2-1.fna&oh=00_AT83b_VQTu8f2XR9sMWf_oHq-sG9o1CtH9sIKlm1aO7UqA&oe=62923356'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        'https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/120073560_1190543801316094_6900054357751563273_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeEzLZt1okZND9sIpCf4A-FUlnBah1AHlkWWcFqHUAeWRbQ5K9Jy3ZeW5WMHIsXGJGJ1hzNwshUhU4r999uopAPV&_nc_ohc=kTVtZHPJUc8AX_46yIu&_nc_ht=scontent.fagu2-1.fna&oh=00_AT_JmY2t-gC9mt2xtjpvlSmxY0qKa8cX1SphRizXOaqkBQ&oe=62B14178'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (venta.pedidos
                                              .map((e) => e.tienda)
                                              .toString())
                                          .replaceAll('(', '')
                                          .replaceAll(')', '')
                                          .replaceAll(',', ' | '),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          GoogleFonts.quicksand(fontSize: 15),
                                    ),
                                    Text(formattedDate,
                                        style: GoogleFonts.quicksand(
                                            fontSize: 13,
                                            color: Colors.grey)),
                                  ],
                                ),
                                Text(
                                  'Orden ID:  ${venta.id}',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.grey.withOpacity(.8),
                                      fontSize: 11),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      'Pedido realizado con exito',
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.8)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(width: 1, color: Colors.black)),
                        child: Center(
                          child: Text(
                            'Salir',
                            style: GoogleFonts.quicksand(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  } else {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const CupertinoAlertDialog(
              title: Text('Espere por favor'),
              content: CupertinoActivityIndicator(),
            ));
  }
}
