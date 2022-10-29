import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<bool> confirmarEliminacion(
    {required BuildContext context,
    required String titulo,
    required num tipo}) async {
  return await showDialog(
      barrierColor: Colors.white,
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(.05)),
                    child: Icon(
                      tipo == 0
                          ? Icons.place
                          : tipo == 1
                              ? Icons.credit_card
                              : Icons.restaurant_menu,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 35),
                    child: Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.black.withOpacity(.1))),
                            child: Center(
                              child: Text(
                                'Eliminar',
                                style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.8)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0))),
                            child: Center(
                              child: Text(
                                'Cancelar',
                                style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.8)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ));
}
