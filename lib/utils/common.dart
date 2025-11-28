import 'package:flutter/foundation.dart';

class Log {
  // static void print(String e) => if(kDebugMode) print(e);
  static void prt(Object e){
    if (kDebugMode) {
      print(e);
    }
  }
}
