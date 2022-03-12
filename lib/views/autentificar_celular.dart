import 'package:delivery/widgets/boton_autentificar_celular.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AutentificarCelular extends StatelessWidget {
  const AutentificarCelular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 70),
      children: [
        Text(
          'Continua con tu celular',
          style:
              GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 22),
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
              border: Border.all(width: 1, color: Colors.grey.withOpacity(.1))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingresa tu numero celular',
                style: GoogleFonts.quicksand(
                    color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Form(
                        key: formKey,
                        child: InternationalPhoneNumberInput(
                          keyboardAction: TextInputAction.done,
                          errorMessage: 'Numero invalido',
                          autoFocus: false,
                          maxLength: 10,
                          hintText: '4741040608',
                          textStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold, fontSize: 22),
                          onInputChanged: (PhoneNumber number) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: PhoneNumber(isoCode: 'MX'),
                          textFieldController: controller,
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: InputBorder.none,
                          onSaved: (PhoneNumber number) {},
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
        BotonAutentificar(
          formKey: formKey,
          controller: controller,
        )
      ],
    );
  }
}
