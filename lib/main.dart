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
      title: 'piConditioner',
      theme: ThemeData(),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'piConditioner'),
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
  double? temp = 0.0;
  String? humidity = '';
  String? status = '';

  @override
  void initState() {
    super.initState();
    _getTemperatureStatus();
  }

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
    Widget titleSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(60.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 4,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade800),
                    child: Text(
                      temp?.round().toString() ?? 'n/a',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'DigitalFont',
                          color: Colors.greenAccent.shade400,
                          fontSize: 75),
                    ),
                  )),
              const Align(
                  alignment: Alignment.topRight,
                  widthFactor: 0.25,
                  heightFactor: 5,
                  child: Text(
                    '\u00B0 F',
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  ))
            ]),
        // Row(children: [
        //   const Text(
        //     'Humidity: ',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(color: Colors.grey, fontSize: 25),
        //   ),
        //   Text(
        //     humidity.toString(),
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //         fontFamily: 'DigitalFont',
        //         color: Colors.greenAccent.shade400,
        //         fontSize: 50),
        //   )
        // ])
      ],
    );

    Widget buttonSection = Column(children: [
      Column(children: [
        Align(
            alignment: Alignment.centerRight,
            widthFactor: 0.125,
            child: IconButton(
              icon: const Icon(
                Icons.power_settings_new,
                size: 70,
              ),
              color: (status == "on") ? Colors.red : Colors.green,
              onPressed: () {
                _togglePower(status);
              },
            ))
      ])
    ]);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              _getTemperatureStatus();
            },
            child: Column(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                children: [
                  Wrap(
                      alignment: WrapAlignment.center,
                      children: [titleSection, buttonSection])
                ]

                // This trailing comma makes auto-formatting nicer for build methods.
                )));
  }
}
