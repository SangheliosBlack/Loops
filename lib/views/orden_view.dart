import 'package:delivery/widgets/order_screen.dart';
import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        controller: controller,
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        children: [
          const SectionOrder(
            titulo: 'Resumen de orden',
            child: OrderItems(),
          ),
          const SectionOrder(
            isPainted: false,
            titulo: 'Direccion envio',
            child: DeliveryOptionsContainer(),
          ),
          SectionOrder(
            isPainted: false,
            titulo: 'Pago',
            child: PaymentSummary(controller: controller),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
