import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NameIcon extends StatelessWidget {
  String firstName;
   Color backgroundColor;
   Color textColor;

   NameIcon(
      {required this.firstName, this.backgroundColor= Colors.blueAccent, this.textColor= Colors.white,});


  String get firstLetter => this.firstName.substring(0, 1).toUpperCase();

  @override
  Widget build(BuildContext context) {
    return FittedBox(

      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: this.backgroundColor,

        ),
        padding: EdgeInsets.all(8.0),
        child: Text(this.firstLetter, style: TextStyle(color: this.textColor)),
      ),
    );
  }
}