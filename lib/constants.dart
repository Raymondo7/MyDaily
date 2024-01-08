import 'package:flutter/material.dart';

import 'database.dart';
final DatabaseHelper dbHelper = DatabaseHelper();

const bleu = Color(0xFF0000F8);
const rouge = Color(0xFFF80000);
const vert = Color(0xFF00F800);
const jaune = Color(0xFFF8F800);
Color rose = Colors.pink;
Color blanc = Colors.white;
const primColor = bleu;
Color secColor = blanc;

TextStyle stylish(double size, Color color){
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: size,
    color: color,
    fontFamily: 'Poppins'
  );
}