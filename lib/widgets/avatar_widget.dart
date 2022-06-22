import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final bool small;
  const AvatarWidget({Key? key, required this.small}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container() /* SizedBox(
      width: width,
      height: width,
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: width,
            child: SvgPicture.asset(
              'assets/peeps/head/head_${small ? authService.usuario.avatar.peinado : authService.mascara.peinado}.svg',
              width: width,
              height: width,
            ),
          ),
          small
              ? Positioned.fill(
                  bottom: -10,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: 100,
                    child: SvgPicture.asset(
                      'assets/peeps/face/face_${small ? authService.usuario.avatar.rostro : authService.mascara.rostro}.svg',
                    ),
                  ),
                )
              : Positioned(
                  bottom: 25,
                  right: 50,
                  child: SizedBox(
                    width: 220,
                    child: SvgPicture.asset(
                      'assets/peeps/face/face_${small ? authService.usuario.avatar.rostro : authService.mascara.rostro}.svg',
                    ),
                  ),
                ),
          small
              ? Positioned.fill(
                  bottom: -5,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/peeps/accessories/accessories_${small ? authService.usuario.avatar.accesorio : authService.mascara.accesorio}.svg',
                    ),
                  ),
                )
              : Positioned.fill(
                  bottom: -30,
                  child: Container(
                    padding: const EdgeInsets.all(60),
                    child: SvgPicture.asset(
                      'assets/peeps/accessories/accessories_${small ? authService.usuario.avatar.accesorio : authService.mascara.accesorio}.svg',
                    ),
                  ),
                ),
          small
              ? Positioned.fill(
                  bottom: -35,
                  child: Container(
                    width: 40,
                    padding: const EdgeInsets.all(11),
                    child: SvgPicture.asset(
                      'assets/peeps/facial/facial_${small ? authService.usuario.avatar.barba : authService.mascara.barba}.svg',
                    ),
                  ),
                )
              : Positioned(
                  right: 28,
                  bottom: -90,
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(60),
                    child: SvgPicture.asset(
                      'assets/peeps/facial/facial_${small ? authService.usuario.avatar.barba : authService.mascara.barba}.svg',
                    ),
                  ),
                )
        ],
      ),
    )*/
        ;
  }
}
