import 'package:flutter/material.dart';
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
      keywords: <String>['game', 'rpg', 'lol', 'app'], 
      childDirected: false);

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: kappId);

    startBanner();
    displayBanner();
  }

  int _increment = 0;
  int _lastIncrement = 0;
  BannerAd myBanner;
  InterstitialAd myInterstitial;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => _reset(),
                      child: Icon(Icons.settings_backup_restore)),
                ],
              ),
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
                    style:
                        TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Last",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBECADE),
                          ),
                        ),
                        Text(
                          _toString(_lastIncrement),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _add() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 60);
    }
    setState(() {
      _increment++;
    });
  }

  String _toString(int value) {
    return value.toString().padLeft(2, '0');
  }

  _reset() {
    setState(() {
      displayInterstitial();
      _lastIncrement = _increment;
      _increment = 0;
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
