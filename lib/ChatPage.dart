import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = [];

  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null; 
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Robot'),
      ),
      body: isConnecting ? Center(child: CircularProgressIndicator(),) : isConnected ? Center(
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
                      isConnected
                      ? _sendMessage('W')
                      : null;
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        isConnected
                        ? _sendMessage('W')
                        : null;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      _timer?.cancel();
                    },
                    onTapCancel: () {
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
                      isConnected
                        ? _sendMessage('A')
                        : null;
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        isConnected
                        ? _sendMessage('A')
                        : null;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      _timer?.cancel();
                    },
                    onTapCancel: () {
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
                      isConnected
                        ? _sendMessage('D')
                        : null;
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        isConnected
                        ? _sendMessage('D')
                        : null;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      _timer?.cancel();
                    },
                    onTapCancel: () {
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
                      isConnected
                        ? _sendMessage('S')
                        : null;
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        isConnected
                        ? _sendMessage('S')
                        : null;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      _timer?.cancel();
                    },
                    onTapCancel: () {
                      _timer?.cancel();
                    },
                  ),
              ],
            ),
          ],
        ),
      ) : Center(child: Text('No se pudo conectar con el dispositivo')),
    );
  }

  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection!.output.add(utf8.encode(text + "\r\n") as Uint8List);
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}