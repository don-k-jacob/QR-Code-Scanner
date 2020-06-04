
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _outputController;
  @override
  initState() {
    super.initState();
    this._outputController = new TextEditingController();
  }
  bool haveUrl(){
    return _outputController.text.isEmpty&&_outputController.text.contains(".");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff191A1D),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height/10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/6,
                      child: InkWell(
                        onTap: _scan,
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:  Color(0xff191A1D),
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
                              ],
                            ),
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
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/15,
                    ),
                    TextField(
                      controller: this._outputController,
                      readOnly: true,
                      maxLines: 2,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.wrap_text,color: haveUrl()?Color(0xffb31217):Colors.grey,),
                        helperText: 'The barcode or qrcode you scan will be displayed in this area.',
                        hintText: 'The barcode or qrcode you scan will be displayed in this area.',
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    haveUrl()?SizedBox():Center(
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xffe52d27),
                                  Color(0xffb31217),
                                ]),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          child: Text("Open"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/15,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/6,
                      child: InkWell(
                        onTap: _scanPhoto,
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:  Color(0xff191A1D),
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
                              ],
                            ),
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
          height: 50,
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



