class PiConditionerStatus {
  final String? temperature;
  final String? humidity;
  final String? status;

  PiConditionerStatus(this.temperature, this.humidity, this.status);
  
  PiConditionerStatus.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'],
        humidity = json['humidity'],
        status = json['status'];
}
