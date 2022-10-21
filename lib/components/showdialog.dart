import 'package:doctor_login_app/styles/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ShowDialog extends StatelessWidget {

  var width;
  var height;

  String data="Doctor login are created on invite only basis by the labs using LabSmart.";


  ShowDialog({this.width, this.height});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width*297.5,
      height: height*60,
      decoration: BoxDecoration(
          color: lightblue,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: kblue)
      ),
      child: Row(
        children: [
          SizedBox(width: width*8,),
          Icon(Icons.info_rounded,color: kblue,),
          SizedBox(width: width*10,),
          Expanded(
            child: Container(
              child: Center(
                child: Text(data,style: TextStyle(
                    color: kblue,
                    fontSize: height*12,
                    fontWeight:   FontWeight.w600,
                    height: 1.5
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
