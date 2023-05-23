import 'dart:async';
import 'package:cleanmate/MainPageWidget.dart';
import 'package:flutter/material.dart';
import 'communication.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

import './SelectBondedDevicePage.dart';
import './ChatPage.dart';
//import './ChatPage2.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermission();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget _page(index) {
    switch (index) {
      case 0:
        return MainPageWidget();
      case 1: 
        return(Center(child: Icon(Icons.person),));
      default:
        return MainPageWidget();
    }
    
  }

  void requestBluetoothPermission() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetooth.request();
    await Permission.locationWhenInUse.request();
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothScan.request();
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
    return Scaffold(
      bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
            unselectedIconTheme: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
            backgroundColor: Color(0xff4D4D4D),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: 40,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        ),
      body: _page(_selectedIndex),
      );

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
}