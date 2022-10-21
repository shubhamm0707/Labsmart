import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class LoginButton extends StatelessWidget {

   String data;


   LoginButton(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      child: Text(data, style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
      ),),
    );
  }
}
