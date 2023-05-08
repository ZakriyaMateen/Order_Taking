import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text text(String label, Color color, FontWeight weight, double size){
  return Text(
    label,
    style: GoogleFonts.lato(
      textStyle: TextStyle(color: color, letterSpacing: .5,fontWeight: weight,fontSize: size),
    ),
  );
}