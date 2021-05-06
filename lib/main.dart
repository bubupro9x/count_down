import 'package:flutter/material.dart';

import 'circular_countdown_timmer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CountDownPage(),
    );
  }
}

class CountDownPage extends StatefulWidget {
  CountDownPage({
    Key key,
  }) : super(key: key);

  @override
  _CountDownPageState createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  CountDownController _controller = CountDownController();
  int _duration = 30;
  bool isStart = false;
  bool isReverse = true;
  int _count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
              if (result != null) {
                _duration = result;
                setState(() {});
              }
            },
            icon: Icon(
              Icons.settings,
              color: Colors.black45,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                CountDownTimer(
                  duration: _duration,
                  initialDuration: 0,
                  controller: _controller,
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  ringColor: Colors.white,
                  ringGradient: null,
                  fillColor: Colors.grey[400],
                  fillGradient: null,
                  backgroundColor: Colors.grey[300],
                  backgroundGradient: null,
                  strokeWidth: 5.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                      fontSize: 33.0,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold),
                  textFormat: CountdownTextFormat.SS,
                  isReverse: true,
                  isReverseAnimation: false,
                  isTimerTextShown: true,
                  autoStart: false,
                  onDone: () {
                    if (_count == 0) {
                      _count++;
                    } else if (_count == 1) {
                      _count = 0;
                      isStart = false;
                      setState(() {});
                    }
                  },
                  onStart: () {},
                  onComplete: () {
                    _controller.restart(duration: _duration, isReverse: false);
                  },
                ),
                Positioned(
                  right: -30,
                  top: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _duration.toString(),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        's',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                if (!isStart) {
                  _controller.restart(
                      duration: 3,
                      isReverse: true,
                      onDone: () {
                        _controller.restart(
                            duration: _duration, isReverse: true);
                      });
                } else {
                  _count = 0;
                  _controller.stop();
                }

                isStart = !isStart;
                setState(() {});
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                    border: Border.all(width: 0.8, color: Colors.black38),
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(isStart ? 'Stop' : 'Start'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  DurationTime _durationTime = DurationTime.s30;
  int time = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.navigate_before,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _durationTime = DurationTime.s30;
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      buildTime('30'),
                      if (_durationTime == DurationTime.s30)
                        Icon(
                          Icons.arrow_drop_up_outlined,
                          color: Colors.grey[400],
                          size: 40,
                        )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _durationTime = DurationTime.s45;
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      buildTime('45'),
                      _durationTime == DurationTime.s45
                          ? Icon(
                              Icons.arrow_drop_up_outlined,
                              color: Colors.grey[400],
                              size: 40,
                            )
                          : SizedBox(
                              height: 40,
                            ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 180,
                child: TextField(
                  onChanged: (data) {
                    if (_durationTime != DurationTime.custom) {
                      _durationTime = DurationTime.custom;
                      setState(() {});
                    }
                    time = int.tryParse(data);
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          borderSide: BorderSide(color: Colors.grey[400])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          borderSide: BorderSide(color: Colors.grey[400])),
                      hintText: 'CUSTOM',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      labelStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  if (_durationTime == DurationTime.custom) {
                    Navigator.pop(context, time);
                  } else if (_durationTime == DurationTime.s30) {
                    Navigator.pop(context, 30);
                  } else {
                    Navigator.pop(context, 45);
                  }
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(2, 2), // changes position of shadow
                        ),
                      ],
                      border: Border.all(width: 0.8, color: Colors.black38),
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Save'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildTime(String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          's',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

enum DurationTime {
  s30,
  s45,
  custom,
}
