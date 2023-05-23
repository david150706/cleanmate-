import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'communication.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './SelectBondedDevicePage.dart';
import './ChatPage.dart';

class MainPageWidget extends StatefulWidget {

  MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
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

  // This code is just a example if you need to change page and you need to communicate to the raspberry again
  void init() async {
    Communication com = Communication();
    await com.connectBl(_address);
    com.sendMessage("Hello");
    setState(() {});
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
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
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
            children: [
              SizedBox(height: 30,),
              ListTile(title: Text('DISPOSITIVOS',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge,), 
            ),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,  
                  crossAxisSpacing: 4.0,  
                  mainAxisSpacing: 8.0, 
                  children: [TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                      child: Icon(Icons.smart_toy, size: 100,),
                      onPressed: () async {
                        //await base.collection('prueba').add({'num': 1});
                        if(_bluetoothState == BluetoothState.STATE_ON){
                        selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SelectBondedDevicePage(checkAvailability: false);
                            },
                          ),
                        );
                    
                        if (selectedDevice != null) {
                          print('Connect -> selected ' + selectedDevice!.address);
                          _startChat(context, selectedDevice!);
                        } else {
                          print('Connect -> no device selected');
                        }
                        }
                        else {
                          final permission =  await FlutterBluetoothSerial.instance.requestEnable();
                          setState(() {});
                          if(permission == true){
                            selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SelectBondedDevicePage(checkAvailability: false);
                            },
                          ),
                        );
                        }
                        if (selectedDevice != null) {
                          print('Connect -> selected ' + selectedDevice!.address);
                          _startChat(context, selectedDevice!);
                        } else {
                          print('Connect -> no device selected');
                        }
                        }
                        
                      },
                    ),],),
            ),
          ]),
      );
  }
  
}