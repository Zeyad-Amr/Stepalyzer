import 'package:control_app/models/point.dart';
import 'package:control_app/widgets/line_titles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  final List<Point> points;

  LineChartWidget({Key key, @required this.points}) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();

    widget.points
        .forEach((e) => spots.add(FlSpot(e.x.toDouble(), e.y.toDouble())));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
        child: Container(
          width: MediaQuery.of(context).size.width * spots.length / 12,
          height: MediaQuery.of(context).size.height,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: spots.length.toDouble(),
              minY: -200,
              maxY: 1200,
              titlesData: LineTitles.getTitleData(),
              axisTitleData: FlAxisTitleData(
                show: true,
                bottomTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'Time x10^-2 (sec)',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                leftTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'Voltage (v)',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                // checkToShowHorizontalLine: (value) => value % 100 == 0,
                horizontalInterval: 100,

                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[400],
                    strokeWidth: 1,
                  );
                },
                drawVerticalLine: true,
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[400],
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 5,

                  // dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
