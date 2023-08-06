import 'package:flutter/material.dart';

import '../imports/import.dart';

//This class contains deffrent widget which can be repeat.

abstract class CommonWidget {
  // This class is abstract. So object of the class cant be created.
  ///It uses for TextSpan with Josefin Light fontFamily.
  static TextSpan getTextSpanLight(
      {required String text, required double fontSize, required Color color}) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: CommonFonts.josefinLight,
      ),
    );
  }

  ///It uses for TextSpan with Josefin Bold fontFamily.
  static TextSpan getTextSpanBold(
      {required String text, required double fontSize, required Color color}) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: CommonFonts.josefinBold,
      ),
    );
  }
}
