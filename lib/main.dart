import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(Counter());

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _increment = 0;
  int _lastIncrement = 0;
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
      Vibration.vibrate(duration: 100);
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
      _lastIncrement = _increment;
      _increment = 0;
    });
  }
}
