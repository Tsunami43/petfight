import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petfight/models/custom_text.dart';

class ShopScreen extends StatelessWidget {

  const ShopScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: 0.05,
        child: Container(
          color: const Color.fromARGB(255, 73, 73, 73).withOpacity(0.8),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: CustomText(
              data: 'Coming soon ...',
              fontSize: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
