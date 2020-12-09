import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/services/meteoModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'localisation_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  //<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /> pour androidmanifest

  void getLocationWeather() async {
    MeteoModel weatherModel = new MeteoModel();
    //getLocation est dans une methode qui attends une donnée future (methode future), donc await
    var weatherData = await weatherModel.getMeteoWithCoordGps();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocalisationScreen(
        openWeatherData: weatherData,
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    getLocationWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
        ),
      ),
    );
  }
}
