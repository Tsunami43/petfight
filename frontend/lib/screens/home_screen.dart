import 'package:flutter/material.dart';
import 'package:petfight/widgets/claim_button.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ClaimButtonWithTimer(),
    );
  }
}
