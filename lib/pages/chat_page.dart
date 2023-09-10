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

class _ChatPage extends State<ChatPage> {
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;
  bool isDisconnecting = false;
  Timer? _timer;
  String result = '';
  bool _isAutomatic = false;

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

  void timerFunction(String char) {
    _timer = Timer.periodic(Duration(milliseconds: 500), (t) {
      isConnected ? _sendMessage(char) : null;
    });
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
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.arrow_upward))),
                            onTap: () {
                              //isConnected ? _sendMessage('W') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              //_timer?.cancel();
                              isConnected ? _sendMessage('W') : null;
                            },
                            onTapUp: (TapUpDetails details) {
                              isConnected ? _sendMessage('X') : null;
                            },
                            onTapCancel: () {
                              isConnected ? _sendMessage('X') : null;
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
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.arrow_back))),
                            onTap: () {
                              //isConnected ? _sendMessage('A') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              isConnected ? _sendMessage('A') : null;
                            },
                            onTapUp: (TapUpDetails details) {
                              isConnected ? _sendMessage('X') : null;
                            },
                            onTapCancel: () {
                              isConnected ? _sendMessage('X') : null;
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
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.arrow_forward))),
                            onTap: () {
                              //isConnected ? _sendMessage('D') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              isConnected ? _sendMessage('D') : null;
                            },
                            onTapUp: (TapUpDetails details) {
                              isConnected ? _sendMessage('X') : null;
                            },
                            onTapCancel: () {
                              isConnected ? _sendMessage('X') : null;
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
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.arrow_downward))),
                            onTap: () {
                              //isConnected ? _sendMessage('S') : null;
                            },
                            onTapDown: (TapDownDetails details) {
                              isConnected ? _sendMessage('S') : null;
                            },
                            onTapUp: (TapUpDetails details) {
                              isConnected ? _sendMessage('X') : null;
                            },
                            onTapCancel: () {
                              isConnected ? _sendMessage('X') : null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple),
                              onPressed: () {
                                if (_isAutomatic) {
                                  setState(() {
                                    _isAutomatic = false;
                                  });
                                  isConnected ? _sendMessage('0') : null;
                                } else {
                                  setState(() {
                                    _isAutomatic = true;
                                  });
                                  isConnected ? _sendMessage('1') : null;
                                }
                              },
                              child: _isAutomatic
                                  ? Text('Detener')
                                  : Text('Modo automático')),
                        ],
                      )
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
