import 'package:flutter/material.dart';
import 'package:qrcodescanner/Screens/Navigation/Generate.dart';
import 'package:qrcodescanner/Screens/Navigation/Settings.dart';
import 'package:qrcodescanner/Screens/Navigation/home.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice='';
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

 static final MobileAdTargetingInfo targetingInfo= new MobileAdTargetingInfo(
   testDevices: <String>[],
   keywords: <String>['scanner','recorder','games','photo'],
   birthday: new DateTime.now(),
  childDirected: true,
 );


  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd(){
    return new BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("Banner event: $event");
        }
    );
  }
 InterstitialAd createInterstitialAd(){
   return new InterstitialAd(
       adUnitId: InterstitialAd.testAdUnitId,
       targetingInfo: targetingInfo,
       listener: (MobileAdEvent event){
         print("Interstitial event: $event");
       }
   );
 }
  Uint8List bytes = Uint8List(0);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd= createBannerAd()..load()..show();
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
//          ButtonIcon(
//            selectedIndex: _selectedIndex,
//            index: 2,
//            iconData: Icons.history,
//            onTap: () {
//              _onItemTapped(2);
//            },
//          ),
          ButtonIcon(
            selectedIndex: _selectedIndex,
            index: 2,
            iconData: Icons.settings,
            onTap: () {
              _onItemTapped(2);
            },
          ),
        ],
      ),
    );

  }
}

List<dynamic> page=[
  Scan(),
  Generate(),
//  History(),
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
