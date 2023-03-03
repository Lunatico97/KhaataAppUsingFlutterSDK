import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData LightTheme(BuildContext context) => ThemeData(
        //       primarySwatch: Colors.deepPurple,
        //       canvasColor: Colors.white,
        //       cardColor: creamColor,
        //       hintColor: lightColor,
        //       unselectedWidgetColor: lightColor,
        colorScheme: ColorScheme.light(),
        fontFamily: GoogleFonts.poppins().fontFamily,
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
//        appBarTheme: AppBarTheme(
//          color: Colors.white,
//          elevation: 0,
//          iconTheme: IconThemeData(color: Colors.black),
//          toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
//          titleTextStyle: Theme.of(context).textTheme.headline6,
//        ),
      );

  static ThemeData DarkTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.poppins().fontFamily,
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.dark(),
//      canvasColor: darkColor,
//      cardColor: lightColor,
//      unselectedWidgetColor: lightColor,
//      hintColor: Colors.white,
//      appBarTheme: AppBarTheme(
//        color: Colors.black,
//        elevation: 0,
//        iconTheme: IconThemeData(color: lightColor),
//        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
//        titleTextStyle: Theme.of(context).textTheme.headline6,
//      )
      );

  //Colors
  static Color creamColor = const Color(0xfff5f5f5);
  static Color darkBluishColor = const Color(0xff403b58);
  static Color darkColor = Vx.gray900;
  static Color lightColor = Vx.indigo600;
}
