import 'dart:convert';
import 'package:http/http.dart';
import 'package:piconditioner_flutter_app/Models/piconditioner_status_model.dart';

class PiConditionerService {
  double? temp = 0.0;
  double? humidity = 0.0;
  String? status = '';

  Future<PiConditionerStatus> getTemperatureStatus() async {
    try {
      var response = await get(Uri.parse('http://192.168.1.94:3000/status'));
      if (response.statusCode == 200) {
        var parsedResult =
            PiConditionerStatus.fromJson(jsonDecode(response.body));
        temp = parsedResult.temperature;
        humidity = parsedResult.humidity;
        status = parsedResult.status;
        return parsedResult;
      } else {
        throw Exception("Unable To Fetch Temp Data");
      }
    } catch (exception) {
      throw Exception("Unable To Fetch Temp Data");
    }
  }

  Future<dynamic> togglePower(String? currenStatus) async {
    if (currenStatus == null) return;
    var response = await get(Uri.parse(
        "http://192.168.1.94:3000/${currenStatus == 'on' ? 'off' : 'on'}"));
    if (response.statusCode == 200) {
      var parsedResult = jsonDecode(response.body);
      status = parsedResult['status'];
      return parsedResult;
    } else {
      throw Exception("Unable To toggle power");
    }
  }
}
