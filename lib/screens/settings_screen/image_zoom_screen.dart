import 'package:flutter/material.dart';

class ImageZoomScreen extends StatelessWidget {

  final String tag;
  final String url;
   ImageZoomScreen({Key? key,required this.tag,required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            height: size.height,
            width: size.width / 1.1,
            child: InteractiveViewer(
              child: Hero(
                tag: tag,
                child: Image.network(
                  '$url',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
