import 'package:app2/Widgets/text.dart';
import 'package:flutter/material.dart';
class WebHomePage extends StatefulWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  var black= Colors.grey[800]!;
  FontWeight bold= FontWeight.bold;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: text('Admin',black , bold, h*0.018),
        ),
    );
  }
}
