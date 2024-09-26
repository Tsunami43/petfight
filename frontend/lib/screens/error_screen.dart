import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';
import 'package:petfight/models/custom_text.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фоновое изображение
          Image.asset(
            ImagesPath.background,
            fit: BoxFit.cover,
          ),
          // Размытие фона
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Контейнер с текстом "Failed"
          Center(
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Серый цвет контейнера
                borderRadius: BorderRadius.circular(20), // Закругленные углы
                border: Border.all(
                  color: Colors.black, // Черный цвет границы
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomText(data: message, fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
