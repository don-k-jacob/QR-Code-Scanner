
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _inputController;
  TextEditingController _outputController;

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    this._buttonGroup(),
                    SizedBox(height: 70),
                    TextField(
                      controller: this._outputController,
                      readOnly: true,
                      maxLines: 2,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.wrap_text),
                        helperText: 'The barcode or qrcode you scan will be displayed in this area.',
                        hintText: 'The barcode or qrcode you scan will be displayed in this area.',
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buttonGroup() {
    return Column(
      children: <Widget>[

        SizedBox(
          height: 120,
          child: InkWell(
            onTap: _scan,
            child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/scan.png'),
                  ),
                  Divider(height: 20),
                  Expanded(flex: 1, child: Text("Scan")),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: InkWell(
            onTap: _scanPhoto,
            child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/albums.png'),
                  ),
                  Divider(height: 20),
                  Expanded(flex: 1, child: Text("Scan Photo")),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _scan() async {
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



