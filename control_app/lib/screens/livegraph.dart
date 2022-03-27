import 'package:control_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveGraph extends StatefulWidget {
  const LiveGraph({Key key}) : super(key: key);

  @override
  State<LiveGraph> createState() => _LiveGraphState();
}

class _LiveGraphState extends State<LiveGraph> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Consumer<Myprovider>(
            builder: (context, value, child) => Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Container())));
  }
}
