import 'dart:async';
import 'package:cleanmate/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/select_bonded_device_page.dart';
import '../pages/chat_page.dart';

class DeviceListWidget extends StatefulWidget {
  DeviceListWidget({super.key});

  @override
  State<DeviceListWidget> createState() => _DeviceListWidgetState();
}

class _DeviceListWidgetState extends State<DeviceListWidget> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FirebaseFirestore base = FirebaseFirestore.instance;
  String _address = "...";
  bool hasPairedDevices = true;
  BluetoothDevice? selectedDevice;

  String _name = "...";

  @override
  void initState() {
    super.initState();
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled)!) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  void _startChat(BuildContext context, String address) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(
            address: address,
          );
        },
      ),
    );
  }

  void requestBluetoothPermission() async {
    await Permission.bluetooth.request();
    await Permission.locationWhenInUse.request();
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    var status = await Permission.bluetooth.status;
    if (await Permission.bluetooth.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .doc('/users/${auth.currentUser!.uid}')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ),
                      onPressed: () async {
                        if (_bluetoothState == BluetoothState.STATE_ON) {
                          selectedDevice = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SelectBondedDevicePage(
                                    checkAvailability: false);
                              },
                            ),
                          );

                          if (selectedDevice != null) {
                            await FirebaseFirestore.instance
                                .doc('/users/${authService.user.id}')
                                .update({
                              'devices': FieldValue.arrayUnion([
                                {'address': selectedDevice!.address}
                              ])
                            });
                            _startChat(context, selectedDevice!.address);
                          }
                        } else {
                          final permission = await FlutterBluetoothSerial
                              .instance
                              .requestEnable();
                          setState(() {});
                          if (permission == true) {
                            selectedDevice = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SelectBondedDevicePage(
                                      checkAvailability: false);
                                },
                              ),
                            );
                          }
                          if (selectedDevice != null) {
                            await FirebaseFirestore.instance
                                .doc('/users/${authService.user.id}')
                                .update({
                              'devices': FieldValue.arrayUnion([
                                {'address': selectedDevice!.address}
                              ])
                            });
                            _startChat(context, selectedDevice!.address);
                          }
                        }
                      })
                  ,
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Text(
                      'Mis Dispositivos',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (snapshot.data!['devices'].length > 0)
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 8.0,
                        children: snapshot.data!['devices'].map<Widget>((e) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffE7DBFF)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurple),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                  color: Color(0xffAF87FF),
                                  width: 5,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.smart_toy,
                              size: 100,
                            ),
                            onPressed: () async {
                              if (_bluetoothState == BluetoothState.STATE_ON) {
                                _startChat(context, e['address']);
                              } else {
                                final permission = await FlutterBluetoothSerial
                                    .instance
                                    .requestEnable();
                                setState(() {});
                                if (permission == true) {
                                  _startChat(context, e['address']);
                                }
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  if (snapshot.data!['devices'].length == 0)
                    Column(
                      children: [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            'Aún no has añadido ningún dispositivo',
                          ),
                        ),
                        SizedBox(height: 20),
                        Icon(
                          Icons.bluetooth_disabled_outlined,
                          size: 70,
                        )
                      ],
                    )
                ]),
              ),
            );
          }
        });
  }
}
