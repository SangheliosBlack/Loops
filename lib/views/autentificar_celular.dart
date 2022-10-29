import 'package:delivery/service/puto_dial.dart';
import 'package:delivery/widgets/boton_autentificar_celular.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class AutentificarCelular extends StatefulWidget {
  const AutentificarCelular({Key? key}) : super(key: key);

  @override
  State<AutentificarCelular> createState() => _AutentificarCelularState();
}

class _AutentificarCelularState extends State<AutentificarCelular> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();

    var number = PhoneNumber(isoCode: 'MX', dialCode: '+52', phoneNumber: '');

    final putoDial = Provider.of<PutoDial>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 70),
        children: [
          Text(
            'Continua con tu celular',
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Recibiras un codigo de 4 digitos \n para verificar',
            style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 15),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(.1))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingresa tu numero celular',
                  style: GoogleFonts.quicksand(color: Colors.black),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Form(
                          key: formKey,
                          child: InternationalPhoneNumberInput(
                            locale: 'es-MX',
                            countrySelectorScrollControlled: false,
                            errorMessage: 'Numero invalido',
                            autoFocus: false,
                            maxLength: 12,
                            inputDecoration: InputDecoration(
                                errorStyle:
                                    GoogleFonts.quicksand(color: Colors.red),
                                hintStyle: GoogleFonts.quicksand(
                                    color: Colors.grey.withOpacity(.4)),
                                border: InputBorder.none,
                                hintText: '474 747 4747'),
                            hintText: '',
                            textStyle: GoogleFonts.quicksand(fontSize: 22),
                            onInputChanged: (PhoneNumber number2) {
                              putoDial.dial = number2.dialCode.toString();
                            },
                            selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                                setSelectorButtonAsPrefixIcon: false,
                                useEmoji: true),
                            ignoreBlank: false,
                            formatInput: true,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: GoogleFonts.quicksand(
                                fontSize: 22, color: Colors.blue),
                            initialValue: number,
                            textFieldController: controller,
                            spaceBetweenSelectorAndTextField: 0,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          BotonAutentificar(formKey: formKey, controller: controller)
        ],
      ),
    );
  }
}
