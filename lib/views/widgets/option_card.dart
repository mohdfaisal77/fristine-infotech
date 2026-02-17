import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;

    Color bgColor = Colors.grey.shade200;

    if (hasAnswered) {
      // If user selected this option
      if (isSelected) {
        if (isCorrect) {
          bgColor = Colors.green;
        } else {
          bgColor = Colors.red;
        }
      }
      // If user selected wrong, also highlight correct answer
      else if (isCorrect) {
        bgColor = Colors.green;
      }
    }



    return GestureDetector(
      onTap: hasAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}


