import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';

class CustomBackground extends StatelessWidget {
  final Widget screen;

  const CustomBackground({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPath.background),
          fit: BoxFit.cover,
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: Center(child: screen)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}