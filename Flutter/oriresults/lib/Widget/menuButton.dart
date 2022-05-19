import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ButtonStyle MenuButton = ButtonStyle(
    textStyle: MaterialStateProperty.all(const TextStyle()),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    fixedSize: MaterialStateProperty.all(Size.fromWidth(320)));
