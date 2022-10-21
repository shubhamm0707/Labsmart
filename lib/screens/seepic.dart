
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/widgets.dart';



class SeePic extends StatelessWidget {

  String url="";


  SeePic({this.url});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
                child: Center(child: CircularProgressIndicator())),
            PhotoView(
              imageProvider: NetworkImage( url
                      ),)
          ],
        ),
      ),
    );
  }
}
