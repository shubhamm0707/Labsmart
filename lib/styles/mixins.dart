import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


const styles= TextStyle(


);

const kblue=Color(0xff1565C0);
const lightblue=Color(0xffC8E2FF);
const skyblue=Color(0xff51FFF5);
const orange=Color(0xffFFC4A3);


showAlert(BuildContext context,String data,{String mgs="Invalid email or invite code.",bool onlytitle=false})
{

  var alertDialog=new AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.white,
    title:Text(mgs),
    content: onlytitle ? null: Text(data),
  );

  showDialog(context: context, builder: (context)=>alertDialog);

}

showAlertDialog(BuildContext context, String data)
{


  var alertDialog=new AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.white,
    content:Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(width: 20,),
        Text(data)
      ],
    ),
  );

  showDialog(
      barrierDismissible: false,
      context: context, builder: (context)=>alertDialog);

}

showSnakbar(BuildContext context,String message,{Color color=Colors.red})
{
  final snackBar = SnackBar(
    backgroundColor: color,
    duration: Duration(seconds: 1),
    content: Text(message),);

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}



var decoration = InputDecoration(
  hintText: 'password',
  enabled: true,
  suffixIcon:  Icon(Icons.remove_red_eye),
  border: border_of_inputfield
);


var border_of_inputfield= OutlineInputBorder(
  borderSide: BorderSide(color: Colors.teal),
  borderRadius: BorderRadius.circular(7.0),
);