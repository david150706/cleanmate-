import 'dart:async';

import 'package:flutter/material.dart';

class RobotControlScreen extends StatefulWidget {
  @override
  _RobotControlScreenState createState() => _RobotControlScreenState();
}

class _RobotControlScreenState extends State<RobotControlScreen> {
  Timer? _timer;
  bool _isUpButtonPressed = false;
  bool _isLeftButtonPressed = false;
  bool _isRightButtonPressed = false;
  bool _isDownButtonPressed = false;
  MaterialStatesController _upState = MaterialStatesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Robot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.arrow_upward)
                ),
                    onTap: (){
                      setState(() {
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      print('down');
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          //Send data
                        });
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      print('up');
                      _timer?.cancel();
                    },
                    onTapCancel: () {
                      print('cancel');
                      _timer?.cancel();
                    },
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.arrow_back)
                ),
                    onTap: (){
                      setState(() {
                        print('down');
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          //Send data
                        });
                        print('down');
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      print('up');
                      _timer?.cancel();
                    },
                    onTapCancel: () {
                      print('cancel');
                      _timer?.cancel();
                    },
                  ),
                SizedBox(
                  width: 70,
                  height: 70,
                ),
                GestureDetector(
                    child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.arrow_forward)
                ),
                    onTap: (){
                      setState(() {
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      print('down');
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          //Send data
                        });
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      print('up');
                      _timer?.cancel();
                    },
                    onTapCancel: () {
                      print('cancel');
                      _timer?.cancel();
                    },
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.arrow_downward)
                ),
                    onTap: (){
                      setState(() {
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      print('down');
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          //Send data
                        });
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      print('up');
                      _timer?.cancel();
                    },
                    onTapCancel: () {
                      print('cancel');
                      _timer?.cancel();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
