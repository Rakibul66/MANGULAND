import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/game_screen.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: GameScreen(),
  ));
}