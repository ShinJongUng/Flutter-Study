import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {

  final color;
  final textColor;
  final String buttonText;

  const Mybutton({ Key ? key, this.color, this.textColor, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: color,
          child: Center(
            child: Text(buttonText, style: TextStyle(color:textColor),),
          ),
        ),
      ),
    );
  }
}

