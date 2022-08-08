// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'main.dart';

// class TemperatureControl extends StatefulWidget {
//   TemperatureControl({super.key});
//   String status = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Temp Controller'),
//         ),
//         body: Center(
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             ElevatedButton(
//               child: const Text('Back'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           const MyHomePage(title: 'PiConditioner')),
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Power'),
//               onPressed: () {
//               var res = _getTemperatureStatus();
//               res.toString();
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Refresh'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           const MyHomePage(title: 'PiConditioner')),
//                 );
//               },
//             )
//           ]),
//         ));
    
//   }
//   Future<http.Response> _getTemperatureStatus() {
//     return http.get(Uri.parse('192.168.1.94:3000/status'));
//   }
// }





//############
