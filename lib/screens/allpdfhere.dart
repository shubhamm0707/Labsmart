
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_login_app/components/downloading_dialog.dart';
import 'package:doctor_login_app/screens/seepic.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'PdfViewPage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AllPdfHere extends StatefulWidget {
  List<Map<String, String>> list;

  AllPdfHere({this.list});

  @override
  _AllPdfHereState createState() => _AllPdfHereState();
}

class _AllPdfHereState extends State<AllPdfHere> {
  String urlPDFPath = "";

  Future<File> getFileFromUrl(url) async {
    try {
      final data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  showAlertDialog(BuildContext context, String data) {
    var alertDialog = new AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Text(data)
        ],
      ),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alertDialog);
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    print("init");
  }

  @override
  Widget build(BuildContext context) {
    print(widget.list);
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reports'),
      ),
      body: Column(
        children: [
          for (MapEntry e in widget.list[0].entries)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Card(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 80),
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/filepdf.svg',
                          width: 60,
                          height: 60,
                          color: Color(0xffA90000),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text(
                                  "${e.key}",
                                  style:
                                  TextStyle(color: kblue, fontSize: 18),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {



                                    if (e.value != null) {
                                      showAlertDialog(context, "Opening pdf");

                                      var url = Uri.parse(e.value);

                                      print(e);
                                      print(url);

                                      getFileFromUrl(url).then((f) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfViewPage(
                                                      path: f.path,
                                                      name: e.key,
                                                    )));
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              border: Border.all(
                                                  color: kblue, width: 2)),
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: kblue,
                                          )),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "View",
                                        style: TextStyle(color: kblue),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () async {

                                    PermissionStatus storage = await Permission.storage.request();
                                    var url = Uri.parse(e.value);

                                    if(storage == PermissionStatus.granted)
                                    {
                                      int count =0;
                                      String name="";

                                      for(int i=0;i<e.value.toString().length;i++)
                                        {
                                          if(e.value.toString()[i]=='/')
                                            {
                                              count++;
                                            }

                                          if(count==5 && e.value.toString()!='/')
                                            {
                                              name=name+e.value.toString()[i];
                                            }
                                        }
                                      print(name);

                                      showDialog(context: context, builder: (context)=>  DownloadingDialog(url:e.value,name: name,));

                                    }
                                    if(storage == PermissionStatus.denied)
                                    {
                                      showSnakbar(context,"It's important to download pdf");
                                    }

                                    if(storage == PermissionStatus.permanentlyDenied)
                                    {
                                      openAppSettings();
                                    }

                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              border: Border.all(
                                                  color: kblue, width: 2)),
                                          child: Icon(
                                            Icons.download_rounded,
                                            color: kblue,
                                          )),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "Download",
                                        style: TextStyle(color: kblue),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}  