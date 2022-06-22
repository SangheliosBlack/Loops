import 'package:flutter/material.dart';

class AdminDashBoard extends StatelessWidget {
  const AdminDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Column(
          children: const [ Icon(Icons.person)],
        )
      ]),
    );
  }
}
