import 'dart:typed_data';

import 'package:control_app/models/point.dart';
import 'package:control_app/provider/provider.dart';
import 'package:control_app/screens/analysis.dart';
import 'package:control_app/screens/livegraph.dart';
import 'package:control_app/screens/normal.dart';
import 'package:control_app/widgets/line_titles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:control_app/Screens/developers.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final BluetoothDevice server;

  const Home({Key key, @required this.server}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  BluetoothConnection connection;
  static List<Widget> _widgetOptions = <Widget>[
    AnalysisScreen(),
    LiveGraph(),
    NormalScreen(),
    DevelopersScreen(),
  ];

  /// Start Bluetooth Connection implementation

  String prevString = '';

  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  String level = '0.0';

  List<String> dataList = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provider = Provider.of<Myprovider>(context, listen: false);
      provider.addPoint(Point(0, 0));
    });

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onData((data) {
        // Allocate buffer for parsed data
        int backspacesCounter = 0;
        data.forEach((byte) {
          if (byte == 8 || byte == 127) {
            backspacesCounter++;
          }
        });
        Uint8List buffer = Uint8List(data.length - backspacesCounter);
        int bufferIndex = buffer.length;

        // Apply backspace control character
        backspacesCounter = 0;
        for (int i = data.length - 1; i >= 0; i--) {
          if (data[i] == 8 || data[i] == 127) {
            backspacesCounter++;
          } else {
            if (backspacesCounter > 0) {
              backspacesCounter--;
            } else {
              buffer[--bufferIndex] = data[i];
            }
          }
        }
        // Create message if there is new line character
        String dataString = String.fromCharCodes(buffer);
        dataList.add(dataString);

        print('data ${dataList.join().split(",").last}');
        try {
          String x = dataList.join().split(",").last;
          double.parse(x);

          level = x;
          print('XXXXX' + level);

          // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          //   var provider = Provider.of<Myprovider>(context, listen: false);
          //   provider.addPoint(
          //       Point((provider.getPoints.length + 1), int.parse(level)));

          // });

          if (!ispaused) {
            spots.add(FlSpot(
                (spots.length + 1).toDouble(), int.parse(level).toDouble()));
          }
        } catch (e) {
          // level = '00.0';
        }

        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
      setState(() {});
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    setState(() {});
  }

  // void _sendMessage(String text, connection) async {
  //   text = text.trim();
  //   if (text.length > 0) {
  //     try {
  //       connection.output.add(utf8.encode(text + "\r\n"));
  //       await connection.output.allSent;
  //     } catch (e) {
  //       setState(() {});
  //     }
  //   }
  // }

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> spots = [FlSpot(0, 0)];
  bool ispaused = false;
  @override
  Widget build(BuildContext context) {
    // var myProv = Provider.of<Myprovider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        title: const Text('Stepalyzer'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: !ispaused
                  ? Icon(Icons.pause_rounded)
                  : Icon(Icons.play_arrow_rounded),
              color: ispaused ? Colors.green : Colors.orange,
              onPressed: () {
                setState(() {
                  ispaused = !ispaused;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.clear_outlined),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  spots = [FlSpot(0, 0)];
                });
              },
            ),
          ),
        ],
      ),
      body: _selectedIndex == 1
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width * spots.length / 12,
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
                          border: Border.all(
                              color: const Color(0xff37434d), width: 1),
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
              ),
            )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              backgroundColor: Colors.grey[900],
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[500],
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              curve: Curves.easeInCubic,
              tabBackgroundGradient: LinearGradient(
                  colors: [Colors.deepPurple[900], Colors.blueAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.7, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 500),
              color: Colors.white,
              tabs: [
                GButton(
                  icon: Icons.warning_amber_outlined,
                  text: 'Restrictions',
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: 'Examining',
                ),
                GButton(
                  icon: Icons.auto_graph_rounded,
                  text: 'Normal',
                ),
                GButton(
                  icon: Icons.developer_mode_rounded,
                  text: 'Developers',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                // myProv.setPoints = [Point(0, 0)];
              },
            ),
          ),
        ),
      ),
    );
  }
}
