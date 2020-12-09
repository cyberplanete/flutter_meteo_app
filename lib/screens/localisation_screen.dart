import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/services/meteoModel.dart';
import 'package:flutter_meteo_app/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'city_screen.dart';

class LocalisationScreen extends StatefulWidget {
  final openWeatherData;
  LocalisationScreen({this.openWeatherData});

  @override
  _LocalisationScreenState createState() => _LocalisationScreenState();
}

class _LocalisationScreenState extends State<LocalisationScreen> {
  MeteoModel meteo = new MeteoModel();
  int temperature;
  String weatherIcon;
  String nomVille;
  String weatherMessage;
  @override
  void initState() {
    // Au démarrage de cette page :
    super.initState();
    print(widget.openWeatherData);
    updateUI(widget.openWeatherData);
  }

//Mise à jour de l'interface
  void updateUI(dynamic openWeatherData) {
    setState(() {
      //Si Aucune donnée reçue
      //TODO concevoir methodes afin de prévoir divers scenarios comme gps desativé ou droits non activés
      if (openWeatherData == null) {
        temperature = 0;
        weatherMessage = 'Unable to get weather data';
        var condition = '';
        weatherIcon = 'error';
        nomVille = '';
        return; //end app prematurely
      }

      double temp = openWeatherData['main']['temp'];
      temperature = temp.toInt();
      weatherMessage = meteo.getMessage(temperature);
      var condition = openWeatherData['weather'][0]['id'];
      weatherIcon = meteo.getWeatherIcon(condition);
      nomVille = openWeatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var openWeatherData = await meteo.getMeteoWithCoordGps();
                      updateUI(openWeatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      //Je recupère le nom de la ville provenant de Navigator.pop onPressed
                      var nomVilleTyped = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      print(nomVilleTyped);
                      if (nomVilleTyped != null) {
                        //TODO Créer un LoadingDialog
                        /*showDialog(
                            context: context,
                            child: new AlertDialog(
                                content: SpinKitWave(
                              color: Colors.white,
                            )));*/
                        var openWeatherData =
                            await meteo.getMeteoOfCityName(nomVilleTyped);

                        updateUI(openWeatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Container(
                child: SpinKitWave(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Text(
                  weatherMessage + ' à ' + nomVille + '!!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
