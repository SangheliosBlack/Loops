import 'package:delivery/service/hide_show_menu.dart';


import 'package:flutter/material.dart';

void customModal(
    BuildContext context, Widget child, GeneralActions generalActions) {
  showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: const Color(0xffFAFAFA),
      builder: (builder) {
        return child;
      });
}

void customModalSimple(
    BuildContext context, Widget child) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xffFAFAFA),
      builder: (builder) {
        return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: child);
      });
}
