import 'package:delivery/global/styles.dart';
import 'package:delivery/service/drawer_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderRegisterView extends StatelessWidget {
  const OrderRegisterView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      drawerAction.openDraw();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: Styles.containerCustom(),
                      child: Icon(
                        FontAwesomeIcons.bars,
                        size: 23,
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                  ),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: Styles.containerCustom(),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Center(
                              child: Icon(
                            Icons.notifications,
                            color: Colors.black.withOpacity(.4),
                          )))),
                ],
              ),
            ),
            Positioned(
                right: 20,
                top: 20,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).primaryColor),
                  child: Center(
                    child: Text(
                      '5',
                      style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
          ],
        ),
        const Text('Registro de ordenes'),
      ],
    );
  }
}