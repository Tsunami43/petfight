import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';
import 'package:petfight/models/custom_text.dart';
import 'package:provider/provider.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InfoProvider infoProvider = Provider.of<InfoProvider>(context);
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
                child: infoProvider.message == null 
                  ? const CircularProgressIndicator(
                    backgroundColor: Colors.red,
                    strokeWidth: 10,
                    color: Colors.black,
                  )
                  : CustomText(data: '${infoProvider.message}', fontSize: 24)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
