import 'package:flutter/material.dart';

class StartMarkerPainter extends CustomPainter {
  final bool type;
  final String texto;

  StartMarkerPainter({required this.type, required this.texto});

  @override
  void paint(Canvas canvas, Size size) {
    final bluePaint = Paint()..color = const Color.fromRGBO(0, 147, 255, 1);
    final greenPaint = Paint()..color = const Color.fromRGBO(63, 225, 127, 1);

    final whitePaint = Paint()..color = Colors.white;

    const double circleBlackRadius = 20;
    const double circleWhiteRadius = 7;

    // Circulo Negro
    canvas.drawCircle(Offset(size.width * 0.5, size.height - circleBlackRadius),
        circleBlackRadius, type ? bluePaint : greenPaint);

    // Circulo Blanco
    canvas.drawCircle(Offset(size.width * 0.5, size.height - circleBlackRadius),
        circleWhiteRadius, whitePaint);

    // Dibujar caja blanca
    final path = Path();
    path.moveTo(10, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(10, 100);

    // Sombra
    canvas.drawShadow(path, Colors.black, 10, false);

    // Caja
    canvas.drawPath(path, whitePaint);

    // Caja Negra
    const blackBox = Rect.fromLTWH(10, 20, 80, 80);
    canvas.drawRect(blackBox, type ? bluePaint : greenPaint);

    // Textos
    // Minutos
    final textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: type ? 'INICIO' : 'FIN');

    final minutesPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: 80, maxWidth: 80);

    minutesPainter.paint(canvas, const Offset(10, 50));

    // Descripción

    final locationText = TextSpan(
        style: const TextStyle(
            height: 1.2,
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w300),
        text: texto);

    final locationPainter = TextPainter(
        maxLines: 2,
        ellipsis: '...',
        text: locationText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(minWidth: size.width - 130, maxWidth: size.width - 130);

    final double offsetY = (texto.length > 25) ? 35 : 48;

    locationPainter.paint(canvas, Offset(110, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
