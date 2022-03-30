import 'dart:convert';

import 'package:control_app/models/point.dart';
import 'package:control_app/widgets/line_chart_widget.dart';
import 'package:flutter/material.dart';

class NormalScreen extends StatefulWidget {
  const NormalScreen({Key key}) : super(key: key);

  @override
  State<NormalScreen> createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  List<Point> points = [
    Point(0, -100),
    // Point(1, ),
    // Point(2, 2),
    Point(3, 600),
    // Point(4, 4),
    Point(5, 300),
    // Point(6, 2),
    Point(7, 400),
    Point(8, 0),
    Point(9, 0),
    Point(10, 0),
    Point(11, 0),
    Point(12, 0),
    Point(13, 0),
    Point(14, 0),
    Point(15, 0),
    // Point(16, 1),
    // Point(17, 2),
    // Point(18, 3),
    // Point(19, 4),
    // Point(20, 3),
    // Point(21, 2),
    // Point(22, 3),
    // Point(23, 3),
    // Point(24, 1),
    // Point(25, 2),
    // Point(26, 3),
    // Point(27, 4),
    // Point(28, 3),
    // Point(29, 2),
    // Point(30, 1)
  ];

  @override
  Widget build(BuildContext context) {
    return LineChartWidget(
      points: points,
    );
  }
}
