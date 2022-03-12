import 'package:flutter/material.dart';

void showModalBottomSheetCustom(BuildContext context, Widget child) {
  showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (builder) {
        return child;
      });
}
