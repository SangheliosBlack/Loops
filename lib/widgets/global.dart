import 'package:flutter/material.dart';

class CarrouselGlobal extends StatelessWidget {
  final PageController controller;
  const CarrouselGlobal({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) => photoItem()),
    );
  }

  Widget photoItem() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: const SizedBox(
        width: double.infinity,
        height: 220,
        child: Image(
          image: NetworkImage(
              'https://traveler.marriott.com/es/wp-content/uploads/sites/2/2019/10/Maverick_interior.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CarrouselGlobal2 extends StatelessWidget {
  final PageController controller;
  final bool isRounded;
  const CarrouselGlobal2(
      {Key? key, required this.controller, required this.isRounded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '12A',
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 200,
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) =>
                    photoItem(isRounded, context)),
          ),
          Positioned(
            bottom: 20,
            left: 40,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  color: Colors.white,
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget photoItem(bool isRounded, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: isRounded ? 15 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isRounded ? 10 : 0),
        child: Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(color: Colors.white),
          child: Icon(
            Icons.add_photo_alternate,
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
        ),
      ),
    );
  }
}
