import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Myprovider extends ChangeNotifier {
  List<int> xList = [];
  List<int> yList = [];

  // int _status = 0;

  BluetoothConnection _connection;

  get connection => this._connection;

  set connection(value) {
    this._connection = value;
    notifyListeners();
  }

  List<int> get getXList => this.xList;

  set setXList(List<int> xList) {
    this.xList = xList;
    notifyListeners();
  }

  List<int> get getYList => this.yList;

  set setYList(List<int> yList) {
    this.yList = yList;
    notifyListeners();
  }
}
