import 'package:flutter_meteo_app/utilities/constants.dart';

import 'localisation.dart';
import 'openWeatherService.dart';

class MeteoModel {
  Future<dynamic> getMeteoWithCoordGps() async {
    Localisation localisation = new Localisation();
    //Je récupère la localisation gps
    await localisation.getCurrentLocalisation();
    print(localisation.latitude);
    print(localisation.longitude);

    OpenWeatherService openWeatherService = new OpenWeatherService(
        url:
            '$kOpenWeatherUrl?lat=${localisation.latitude}&lon=${localisation.longitude}&appid=$kApiKey&units=metric');
//Je fais un appel OpenWeatherMap avec la localisation gps
    var weatherData = await openWeatherService.getData();
    return weatherData;
  }

  Future<dynamic> getMeteoOfCityName(String cityName) async {
    OpenWeatherService openWeatherService = new OpenWeatherService(
        url: '$kOpenWeatherUrl?q=$cityName&appid=$kApiKey&units=metric');
    var openWeatherData = await openWeatherService.getData();
    return openWeatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'C\'est le moment pour 🍦 ';
    } else if (temp > 20) {
      return 'c\'est le moment pour les shorts et 👕';
    } else if (temp < 10) {
      return 'Vous aurez besoin d\'une 🧣 et de 🧤';
    } else {
      return 'Apportez un 🧥 juste au cas où';
    }
  }
}
