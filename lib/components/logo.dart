import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Logo extends StatelessWidget {

  var width;
  var height;


  Logo({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width*200,
      height: height*80,
      decoration: BoxDecoration(
      ),
      child: Image.asset("assets/images/logo.png",width: width/1.5,height:height/11.4,fit: BoxFit.fitWidth,),
    );
  }
}
