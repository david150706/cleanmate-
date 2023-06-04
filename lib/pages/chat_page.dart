import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final String address;

  const ChatPage({required this.address});

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
  String result = '';

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    }).catchError((error) {
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      print('Cannot connect, exception occured');
      print(isConnecting);
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
      body: isConnecting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isConnected
              ? Center(
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
                                child: Icon(Icons.arrow_upward)),
                            onTap: () {
                              isConnected ? _sendMessage('W') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 500), (t) {
                                isConnected ? _sendMessage('W') : null;
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
                                child: Icon(Icons.arrow_back)),
                            onTap: () {
                              isConnected ? _sendMessage('A') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 500), (t) {
                                isConnected ? _sendMessage('A') : null;
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
                                child: Icon(Icons.arrow_forward)),
                            onTap: () {
                              isConnected ? _sendMessage('D') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 500), (t) {
                                isConnected ? _sendMessage('D') : null;
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
                                child: Icon(Icons.arrow_downward)),
                            onTap: () {
                              isConnected ? _sendMessage('S') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 500), (t) {
                                isConnected ? _sendMessage('S') : null;
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
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No se pudo conectar con el dispositivo',
                          style: Theme.of(context).textTheme.displayMedium),
                      SizedBox(height: 20),
                      Icon(Icons.sentiment_very_dissatisfied_rounded, size: 70),
                    ],
                  ),
                ),
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

  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    result = String.fromCharCodes(buffer);
  }
}
