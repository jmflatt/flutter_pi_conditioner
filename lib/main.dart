import 'package:flutter/material.dart';
import 'package:piconditioner_flutter_app/Services/pi_conditioner_service.dart';
import 'package:piconditioner_flutter_app/temperature_control.dart';
import 'Services/service_locator.dart';

void main() {
  setupServiceLocator();
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
  double? humidity = 0.0;
  String? status = '';
  bool loading = false;
  final PiConditionerService _piConditionerService =
      getIt<PiConditionerService>();

  @override
  void initState() {
    super.initState();
    _setTempDetails();
  }

  _setTempDetails() async {
    var details = await _piConditionerService.getTemperatureStatus();
    setState(() {
      temp = details.temperature;
      humidity = details.humidity;
      status = details.status;
    });
    // setState(() {
    //   temp = 99;
    //   humidity = 40;
    //   status = "off";
    // });
  }

  _togglePower(status) async {
    var result = await _piConditionerService.togglePower(status);
    setState(() {
      // status = "on";
      status = result['status'];
    });
  }

  Future<void> _refreshData() async {
    var details = await _piConditionerService.getTemperatureStatus();
    // await Future.delayed(const Duration(seconds: 2));
    setState(() {
      temp = details.temperature;
      humidity = details.humidity;
      status = details.status;
    });
    // setState(() {
    //   temp = 100.0; // details.temperature;
    //   humidity = 50.0; // details.humidity;
    //   status = "on"; // details.status;
    //   loading = false;
    // });
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
          ),
      body: SizedBox.expand(
          child: GestureDetector(
              onHorizontalDragEnd: (details) {
                // Swiping in left direction.
                if (details.velocity.pixelsPerSecond.dx < 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PiConditionerDetail()),
                  );
                }
              },
              onVerticalDragEnd: (details) async {
                // Swiping in right direction.
                if (details.velocity.pixelsPerSecond.dy > 1) {
                  setState(() {
                    loading = true;
                  });
                  await _refreshData();
                }
              },
              child: !loading
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                          Image.asset(
                            'images/pi-conditioner-logo.jpg',
                            fit: BoxFit.cover,
                          ),
                          Wrap(
                              alignment: WrapAlignment.center,
                              children: [titleSection, buttonSection])
                        ]
                      )
                  : const Icon(Icons.refresh))),
    );
  }
}
