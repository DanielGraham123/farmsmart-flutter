
import 'package:farmsmart_flutter/utils/colors.dart';
import 'package:flutter/painting.dart';

abstract class Styles {

  static TextStyle titleTextStyle() {
    return TextStyle(fontSize: 27, fontWeight: FontWeight.normal, color: Color(black));
  }

  static TextStyle subtitleTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(primaryGreen));
  }

  static TextStyle appBarTextStyle() {
    return TextStyle(fontSize: 22,  fontWeight: FontWeight.bold,  color: Color(primaryGrey), letterSpacing: 1);
  }

  static TextStyle footerTextStyle() {
    return TextStyle(fontSize: 12, color: Color(black), decorationColor: Color(primaryGreen));
  }

}
