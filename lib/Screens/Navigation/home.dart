
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_admob/firebase_admob.dart';
const String testDevice='';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}
bool haveUrl;

class _ScanState extends State<Scan> {

  static final MobileAdTargetingInfo targetingInfo= new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['scanner','recorder','games','photo'],
    birthday: new DateTime.now(),
    childDirected: true,
  );

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
  Future<void> _launched;
  Uint8List bytes = Uint8List(0);
  TextEditingController _outputController;
  @override
  initState() {
    FirebaseAdMob.instance.initialize(appId:"ca-app-pub-8002601004224879~3774691612");
    _bannerAd= createBannerAd()..load()..show(anchorOffset: 100);
    super.initState();
    haveUrl=false;
    this._outputController = new TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
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
                        onTap:(){
                          _scan();
                          _interstitialAd..load()..show();
                        },
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.wrap_text,color: haveUrl?Color(0xffb31217):Colors.grey,),
                        helperText: 'The barcode or qrcode you scan will be displayed in this area.',
                        hintText: 'The barcode or qrcode you scan will be displayed in this area.',
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    haveUrl?Center(
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _launched = _launchInBrowser(this._outputController.text);
                            });
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
                    ):SizedBox(),
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
    if(barcode.contains("."))
      {
        setState(() {
          haveUrl=true;
        });
      }
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    this._outputController.text = barcode;
    if(barcode.contains("."))
    {
      setState(() {
        haveUrl=true;
      });
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.black,
        content: Text('Could not launch $url',style: TextStyle(
          color: Colors.white
        ),
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      throw 'Could not launch $url';
    }
  }
}



