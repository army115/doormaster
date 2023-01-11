import 'package:doormster/components/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';

class Test extends StatefulWidget {
  Test({Key? key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String _data = '';
  bool _scanning = false;
  FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();

  @override
  void initState() {
    super.initState();

    _bluetooth.devices.listen((device) {
      setState(() {
        _data += device.name + ' (${device.address})\n';
      });
    });
    _bluetooth.scanStopped.listen((device) {
      setState(() {
        _scanning = false;
        _data += 'scan stopped\n';
      });
    });
  }

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  static const platform = MethodChannel('samples.flutter.dev/doormster');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(_batteryLevel),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                  child: Text('Test Java'),
                  onPressed: () {
                    _getBatteryLevel();
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                  child: Text(_scanning ? 'Stop scan' : 'Start scan'),
                  onPressed: () async {
                    try {
                      if (_scanning) {
                        await _bluetooth.stopScan();
                        debugPrint("scanning stoped");
                        setState(() {
                          _data = '';
                        });
                      } else {
                        await _bluetooth.startScan(pairedDevices: false);
                        debugPrint("scanning started");
                        setState(() {
                          _scanning = true;
                        });
                      }
                    } on PlatformException catch (e) {
                      debugPrint(e.toString());
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                  child: Text('Check permissions'),
                  onPressed: () async {
                    try {
                      await _bluetooth.requestPermissions();
                      print('All good with perms');
                    } on PlatformException catch (e) {
                      debugPrint(e.toString());
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
