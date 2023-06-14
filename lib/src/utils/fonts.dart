import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lato = GoogleFonts.roboto();
TextTheme latoTextTheme(TextTheme theme) => GoogleFonts.robotoTextTheme(theme);
final latoBold = lato.copyWith(fontWeight: FontWeight.bold);
final latoWhite = lato.copyWith(color: Colors.white);
