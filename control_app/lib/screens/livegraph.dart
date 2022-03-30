import 'package:control_app/models/point.dart';
import 'package:control_app/provider/provider.dart';
import 'package:control_app/widgets/line_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveGraph extends StatefulWidget {
  const LiveGraph({
    Key key,
  }) : super(key: key);

  @override
  State<LiveGraph> createState() => _LiveGraphState();
}

class _LiveGraphState extends State<LiveGraph> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
        builder: (context, value, child) => Container(
                child: LineChartWidget(
              points: value.getPoints,
            )));
  }
}
