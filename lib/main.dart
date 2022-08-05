import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Models/piconditioner_status_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? temp = '';
  String? humidity = '';
  String? status = '';

  Future _getTemperatureStatus() async {
    try {
      var response = await get(Uri.parse('http://192.168.1.94:3000/status'));
      if (response.statusCode == 200) {
        var parsedResponse =
            PiConditionerStatus.fromJson(jsonDecode(response.body));
        setState(() {
          temp = parsedResponse.temperature;
          humidity = parsedResponse.humidity;
          status = parsedResponse.status;
        });
      } else {
        throw Exception("Unable To Fetch Temp Data");
      }
    } catch (exception) {
      throw Exception("Unable To Fetch Temp Data");
    }
  }

  Future _togglePower(String? currenStatus) async {
    if (currenStatus == null) return;
    var response = await get(
        Uri.parse("http://192.168.1.94:3000/${status == 'on' ? 'off' : 'on'}"));

    if (response.statusCode == 200) {
      var parsedResponse = jsonDecode(response.body);
      setState(() {
        status = parsedResponse['status'];
      });
    } else {
      throw Exception("Unable To toggle power");
    }
  }

  @override
  Widget build(BuildContext context) {
    _getTemperatureStatus();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: 
            Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
            IconButton(
            icon: Image.asset('images/RefreshButton.png'),
            iconSize: 50,
            onPressed: () {
              _getTemperatureStatus();
            },
          ),
          IconButton(
            icon: Image.asset('images/PowerSymbol.png'),
            iconSize: 50,
            onPressed: () {
              _togglePower(status);
            },
          )
        ])
            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
