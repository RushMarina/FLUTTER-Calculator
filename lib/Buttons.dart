import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String buttonText;

  MyButton({required this.color, required this.textColor, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: color,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: 26, // Размер текста кнопки
                fontWeight: FontWeight.bold,// Жирный шрифт
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
