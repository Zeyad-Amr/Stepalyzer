import 'package:control_app/models/point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Myprovider extends ChangeNotifier {
  List<Point> _points = [];

  BluetoothConnection _connection;

  get connection => this._connection;

  set connection(value) {
    this._connection = value;
    notifyListeners();
  }

  get getPoints => this._points;

  set setPoints(List<Point> points) {
    this._points = points;
    notifyListeners();
  }

  addPoint(Point point) {
    this._points.add(point);

    notifyListeners();
  }
}
