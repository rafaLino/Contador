import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_admob/firebase_admob.dart';
import './const/constants.dart';

void main() => runApp(Counter());

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['game', 'rpg', 'lol', 'app'], childDirected: false);
  SharedPreferences _prefs;
  int _increment = 0;
  BannerAd myBanner;
  InterstitialAd myInterstitial;

  @override
  void initState() {
    initIncrement();
    FirebaseAdMob.instance.initialize(appId: kappId);
    startBanner();
    displayBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF020100),
      ),
      home: GestureDetector(
        onTap: () => _add(),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => _reset(),
                      child: Icon(Icons.settings_backup_restore)),
                  Center(
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(200))),
                      child: Center(
                          child: Text(
                        _toString(_increment),
                        style: TextStyle(
                            fontSize: 120, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  initIncrement() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _increment = (_prefs.getInt('increment') ?? 0);
    });
  }

  _add() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 60);
    }
    setState(() {
      _increment = (_prefs.getInt('increment') ?? 0) + 1;
      _prefs.setInt('increment', _increment);
    });
  }

  String _toString(int value) {
    if (value == null) return "00";
    return value.toString().padLeft(2, '0');
  }

  _reset() {
    setState(() {
      displayInterstitial();
      _increment = 0;
      _prefs.remove('increment');
    });
  }

  void startBanner() {
    myBanner = BannerAd(
      adUnitId: kbannerId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened) {
          // MobileAdEvent.opened
          // MobileAdEvent.clicked
          // MobileAdEvent.closed
          // MobileAdEvent.failedToLoad
          // MobileAdEvent.impression
          // MobileAdEvent.leftApplication
        }
        print("BannerAd event is $event");
      },
    );
  }

  void displayBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  void displayInterstitial() {
    myInterstitial = buildInterstitial()
      ..load()
      ..show();
  }

  InterstitialAd buildInterstitial() {
    return InterstitialAd(
        adUnitId: kintersticialId,
        targetingInfo: MobileAdTargetingInfo(),
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myInterstitial?.show();
          }
          if (event == MobileAdEvent.clicked || event == MobileAdEvent.closed) {
            myInterstitial.dispose();
          }
        });
  }

  @override
  void dispose() {
    myBanner?.dispose();
    myInterstitial?.dispose();
    super.dispose();
  }
}
