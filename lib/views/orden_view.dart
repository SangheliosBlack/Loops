import 'package:delivery/widgets/order_screen.dart';
import 'package:flutter/material.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: const Color(0xffF3F5F6),
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Column(
          children: const [
            SectionOrder(
              child: OrderItems(),
              titulo: 'Resumen de orden',
            ),
            SectionOrder(
              isPainted: false,
              child: DeliveryOptionsContainer(),
              titulo: 'Direccion envio',
            ),
            SectionOrder(
              isPainted: false,
              child: PaymentSummary(),
              titulo: 'Pago',
            ),
          ],
        ),
      ),
    );
  }
}
