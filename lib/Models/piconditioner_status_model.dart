import 'package:flutter/rendering.dart';

class PiConditionerStatus {
  final double? temperature;
  final String? humidity;
  final String? status;

  PiConditionerStatus(this.temperature, this.humidity, this.status);
  
  PiConditionerStatus.fromJson(Map<String, dynamic> json)
      : temperature = ((double.parse(json['temperature']) * (9/5)) + 32),
        humidity = json['humidity'],
        status = json['status'];
}
