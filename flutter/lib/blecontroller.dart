// filename: blecontroller.dart
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';

class BleController {
  final frb = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> c;
  late QualifiedCharacteristic tx;
  late String devId;
  var status = 'connect to bluetooth'.obs;
  List<int> packet = [0, 0];
  
  void setMac(String mac){
    devId = mac;}
  
  void send(val) async{
    await frb.writeCharacteristicWithoutResponse(tx, value: val);}    

  void connect() async {
    status.value = 'connecting...';
    c = frb.connectToDevice(id: devId).listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        status.value = 'connected!';

        tx = QualifiedCharacteristic(
            serviceId:        Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
            characteristicId: Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"),
            deviceId: devId);
}});}}
