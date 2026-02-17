import 'package:flutter/material.dart';

class LifeIndicator extends StatelessWidget {
  final int lives;

  const LifeIndicator({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        lives,
            (index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Icons.favorite, color: Colors.red),
        ),
      ),
    );
  }
}
