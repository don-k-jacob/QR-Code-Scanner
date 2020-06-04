import 'package:flutter/material.dart';
import 'package:qrcodescanner/Screens/Navigation/Generate.dart';
import 'package:qrcodescanner/Screens/Navigation/History.dart';
import 'package:qrcodescanner/Screens/Navigation/Settings.dart';
import 'package:qrcodescanner/Screens/Navigation/home.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _inputController;
  TextEditingController _outputController;


  int _selectedIndex = 0;


  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor:  Color(0xff191A1D),
        bottomNavigationBar: RaisedNavBar(context),
        body: page[_selectedIndex]
    );
  }

  Container RaisedNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff191A1D),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius:
            10.0,
            // has the effect of softening the shadow
            offset: Offset(
              7.0, // horizontal, move right 10
              7.0, // vertical, move down 10
            ),
          ),
          BoxShadow(
            color: Color(0xff292A2F),
            blurRadius:
            10.0,
            // has the effect of softening the shadow
            offset: Offset(
              -5.0, // horizontal, move right 10
              -5.0, // vertical, move down 10
            ),
          ),
        ],),
      height: 100,
      width: (MediaQuery.of(context).size.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ButtonIcon(
            selectedIndex: _selectedIndex,
            index: 0,
            iconData: Icons.scanner,
            onTap: () {
              _onItemTapped(0);
            },
          ),
          ButtonIcon(
            selectedIndex: _selectedIndex,
            index: 1,
            iconData: Icons.note_add,
            onTap: () {
              _onItemTapped(1);
            },
          ),
          ButtonIcon(
            selectedIndex: _selectedIndex,
            index: 2,
            iconData: Icons.history,
            onTap: () {
              _onItemTapped(2);
            },
          ),
          ButtonIcon(
            selectedIndex: _selectedIndex,
            index: 3,
            iconData: Icons.settings,
            onTap: () {
              _onItemTapped(3);
            },
          ),
        ],
      ),
    );

  }


   Future scan() async {
    String barcode = await scanner.scan();
    this._outputController.text = barcode;
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    this._outputController.text = barcode;
  }

  Future _scanPath(String path) async {
    String barcode = await scanner.scanPath(path);
    this._outputController.text = barcode;
  }

  Future _scanBytes() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    Uint8List bytes = file.readAsBytesSync();
    String barcode = await scanner.scanBytes(bytes);
    this._outputController.text = barcode;
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
}

List<dynamic> page=[
  Scan(),
  Generate(),
  History(),
  Settings()
];
class ButtonIcon extends StatelessWidget {
  const ButtonIcon(
      {@required int selectedIndex,
        @required this.iconData,
        @required this.index,
        @required this.onTap})
      : _selectedIndex = selectedIndex;

  final int _selectedIndex;
  final IconData iconData;
  final int index;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: (_selectedIndex == index)
                    ? Colors.black
                    : Color(0xff191A1d),
                blurRadius: 10.0, // has the effect of softening the shadow
                spreadRadius: 5.0, // has the effect of extending the shadow
                offset: Offset(
                  7.0, // horizontal, move right 10
                  7.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Container(
            height: 55,
            width: 55,
            color: Color(0xff191A1d),
            child: Center(
              child: (_selectedIndex == index)
                  ? RadiantGradientMask(
                  child: Icon(
                    iconData,
                    size: 40,
                  ))
                  : Icon(iconData, size: 40, color: Color(0xffBDBDBD)),
            ),
          )),
    );
  }

}



class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xffe52d27),
          Color(0xffb31217),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
