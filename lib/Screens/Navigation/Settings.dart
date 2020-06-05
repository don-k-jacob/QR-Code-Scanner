import 'package:flutter/material.dart';
import 'package:qrcodescanner/Screens/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> _launched;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff191A1D),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
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
              width: (MediaQuery
                  .of(context)
                  .size
                  .width),
              height: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset('assets/images/scan.png'),
                    SizedBox(width: 20,),
                    Text("Settings",style: TextStyle(
                        fontSize: 22
                    ),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _launched = _launchInBrowser("");
                });
              },
              child: Tile(iconData: Icons.star,
                txt: "Rate Us",
              ),
            ),
            Divider(
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _launched = _launchInBrowser("https://www.donkjacob.me/");
                });
              },
              child: Tile(
                iconData: Icons.info,
                txt: "About Us",
              ),
            ),
            Divider(
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _launched = _launchInBrowser("https://www.donkjacob.me/");
                });
              },
              child: Tile(iconData: Icons.note,
                txt: "Privacy Policy",
              ),
            ),
            Divider(
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _launched = _launchInBrowser("https://www.donkjacob.me/");
                });
              },
              child: Tile(iconData: Icons.business                                                                                                                                                                                                                                                                                                                                                                                                                                              ,
                txt: "Terms of Service",
              ),
            ),
            Spacer(),
            Text("Version 1.0",style:TextStyle(
              fontSize: 20
            ),),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _launched = _launchInBrowser("https://www.donkjacob.me/");
                });
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("developded with  "),
                    Icon(Icons.favorite,color: Color(0xffb31217),),
                    Text("  by don_k_jacob"),

                  ],
                ),
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
class Tile extends StatelessWidget {
  final IconData iconData;
  final String txt;
  Tile({this.iconData,this.txt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 29,horizontal: 25),
      child: Row(
        children: <Widget>[
          RadiantGradientMask(
            child: Icon(iconData,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(txt,
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }
}