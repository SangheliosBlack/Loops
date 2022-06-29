import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Column(
                children: const [
                   CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
