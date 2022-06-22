import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 100,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Conexion perdida...',
                style:
                    GoogleFonts.quicksand(color: Colors.black.withOpacity(.8)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
