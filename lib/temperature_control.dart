import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Services/pi_conditioner_service.dart';
import 'Services/service_locator.dart';
import 'main.dart';

class PiConditionerDetail extends StatelessWidget {
  PiConditionerDetail({super.key});
  final PiConditionerService _piConditionerService =
      getIt<PiConditionerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Temp Controller'),
        ),
        body: Column(children: [
          Align(
              alignment: Alignment.center,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 3,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade800),
                        child: Text(
                          _piConditionerService.status.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'DigitalFont',
                              color: Colors.greenAccent.shade400,
                              fontSize: 25),
                        ))
                  ])),
          Align(
              alignment: Alignment.center,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 3,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade800),
                        child: Text(
                          _piConditionerService.temp?.round().toString() ??
                              'n/a',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'DigitalFont',
                              color: Colors.greenAccent.shade400,
                              fontSize: 30),
                        )),
                    const Align(
                        alignment: Alignment.topRight,
                        widthFactor: 1,
                        heightFactor: 2.5,
                        child: Text(
                          '\u00B0 F',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ))
                  ])),
          Align(
              alignment: Alignment.center,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 3,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade800),
                        child: Text(
                          _piConditionerService.humidity?.round().toString() ??
                              'n/a',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'DigitalFont',
                              color: Colors.greenAccent.shade400,
                              fontSize: 30),
                        )),
                    const Align(
                      alignment: Alignment.topRight,
                      widthFactor: 1,
                      heightFactor: 0.5,
                      child: Icon(Icons.water_drop_outlined,
                          size: 20, color: Colors.blue),
                    ),
                    const Align(
                        alignment: Alignment.topRight,
                        widthFactor: 1,
                        heightFactor: 2,
                        child: Text(
                          '%',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))
                  ]))
        ]));
  }
}
