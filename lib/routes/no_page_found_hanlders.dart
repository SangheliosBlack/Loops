import 'package:delivery/views/no_pafe_found_view.dart';
import 'package:fluro/fluro.dart';

class NoPageFoundHandlers {

  static Handler noPageFound = Handler(handlerFunc: (context, params) {
    return const NoPageFoundView();
  });
  
}
