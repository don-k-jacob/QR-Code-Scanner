import 'dart:typed_data';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Generate extends StatefulWidget {
  @override
  _GenerateState createState() => _GenerateState();
}
class _GenerateState extends State<Generate> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _inputController;
  TextEditingController _outputController;
  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd(){
    return new InterstitialAd(
        adUnitId: "ca-app-pub-8002601004224879/4896201595",
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("Interstitial event: $event");
        }
    );
  }
  static final MobileAdTargetingInfo targetingInfo= new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['scanner','recorder','games','photo'],
    birthday: new DateTime.now(),
    childDirected: true,
  );
  BannerAd createBannerAd(){
    return new BannerAd(
        adUnitId: "ca-app-pub-8002601004224879/4910505856",
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("Banner event: $event");
        }
    );
  }
  @override
  initState() {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-8002601004224879~3774691612");
    _bannerAd= createBannerAd()..load()..show(anchorOffset: 100);
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.verified_user, size: 18, color: Colors.green),
                  Text('Generate Qrcode', style: TextStyle(fontSize: 15)),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xffe52d27),
                        Color(0xffb31217),
                      ]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: bytes.isEmpty
                        ? Center(
                            child: Text('Empty code ... ',
                                style: TextStyle(color: Colors.white)),
                          )
                        : Image.memory(bytes),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: bytes.isEmpty?LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0x22e52d27),
                                    Color(0x22e52d27),
                                  ]):LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xffe52d27),
                                    Color(0xffb31217),
                                  ]),
                              borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: MediaQuery.of(context).size.width/4,
                            child: Center(
                              child: Text(
                                'Share',
                                style:
                                    TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          onTap: () {
//                            this.setState(() => this.bytes = Uint8List(0));
                          }
                        ),

                        GestureDetector(
                          onTap: () async {
                            final success =
                                await ImageGallerySaver.saveImage(this.bytes);
                            print(success+"\n\n\n");
                            if (success!=null) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Text('Successful Preservation!',style: TextStyle(
                                    color: Colors.white
                                ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Text('Save failed!',style: TextStyle(
                                    color: Colors.white
                                ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: bytes.isEmpty?LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0x22e52d27),
                                      Color(0x22e52d27),
                                    ]):LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xffe52d27),
                                      Color(0xffb31217),
                                    ]),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: MediaQuery.of(context).size.width/4,
                            child: Text(
                              'save',
                              style:
                                  TextStyle(fontSize: 15,),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              _qrCodeWidget(this.bytes, context),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: this._inputController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) => _generateBarCode(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                  ),

                  prefixIcon: Icon(Icons.text_fields),
                  helperText: 'Please input your code to generage qrcode image.',
                  hintText: 'Please Input Your Code',
                  hintStyle: TextStyle(fontSize: 15),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/6,
                child: InkWell(
                  onTap: ()=>_generateBarCode(this._inputController.text),
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
                            child: Image.asset('assets/images/generate_qrcode.png'),
                          ),
                          Divider(height: 20),
                          Expanded(flex: 1, child: Text("Generate QR Code")),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
