import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class DownloadingDialog extends StatefulWidget {

  String url="";
  String name="";


  DownloadingDialog({this.url,this.name});

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {

  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async {

    print(widget.url);

    String fileName = widget.name;

    String path = await getDownloadPath(fileName);

    await dio.download(
      widget.url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });

        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      print("done "+ path);
      Navigator.pop(context);
    }).then((_) =>{
        showSnakbar(context, 'File has been downloaded.',color: Colors.green),

    }).then((value) => OpenFile.open(path));
  }


  Future<String> getDownloadPath(String filename) async {
    Directory directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return "${directory.path}/$filename";
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}