class PiConditionerStatus {
  final double? temperature;
  final double? humidity;
  final String? status;

  PiConditionerStatus(this.temperature, this.humidity, this.status);
  
  PiConditionerStatus.fromJson(Map<String, dynamic> json)
      : temperature = ((double.parse(json['temperature']) * (9/5)) + 32),
        humidity = double.parse(json['humidity']),
        status = json['status'];
}
