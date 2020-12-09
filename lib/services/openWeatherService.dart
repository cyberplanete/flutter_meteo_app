import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenWeatherService {
  final String url;
  OpenWeatherService({this.url});

  Future getData() async {
    //as http
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      String data = response.body;

      //****************************************************
      //Apporte un controle des données plus précis type dynamic
      var decodedData = jsonDecode(data);

      //vers ensuite un type de donnée plus précis
      //Todo Si non double alors erreur !!
      double temp = decodedData['main']['temp'];
      int condition = decodedData['weather'][0]['id'];
      String timeZone = decodedData['name'];
      print(temp);
      print(condition);
      print(timeZone);
      //************************************
      return decodedData;
    } else {
      print('Response status: ${response.statusCode}');
    }
  }
}
