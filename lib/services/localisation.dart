import 'dart:async';

import 'package:geolocation/geolocation.dart';

class Localisation {
  double longitude;
  double latitude;

  Future<void> getCurrentLocalisation() async {
    LocationResult result = await Geolocation.lastKnownLocation();
    if (result.isSuccessful) {
      // location request successful, location is guaranteed to not be null
      latitude = result.location.latitude;
      longitude = result.location.longitude;
    } else {
      switch (result.error.type) {
        case GeolocationResultErrorType.runtime:
          print('runtime error, check result.error.message');
          break;
        case GeolocationResultErrorType.locationNotFound:
          print('location request did not return any result');
          break;
        case GeolocationResultErrorType.serviceDisabled:
          print(' location services disabled on device'); //
          print(
              'might be that GPS is turned off, or parental control (android)');
          break;
        case GeolocationResultErrorType.permissionNotGranted:
          print(' location has not been requested yet'); //
          print(
              ' app must request permission in order to access the location'); //
          break;
        case GeolocationResultErrorType.permissionDenied:
          print('user denied the location permission for the app');
          print(
              'rejection is final on iOS, and can be on Android if user checks `don\'t ask again`'); //
          print(
              ' user will need to manually allow the app from the settings, see requestLocationPermission(openSettingsIfDenied: true)'); //
          break;
        case GeolocationResultErrorType.playServicesUnavailable:
          print(' android only'); //
          print(
              ' result.error.additionalInfo contains more details on the play services error'); //
          switch (
              result.error.additionalInfo as GeolocationAndroidPlayServices) {
            // do something, like showing a dialog inviting the user to install/update play services
            case GeolocationAndroidPlayServices.missing:
            case GeolocationAndroidPlayServices.updating:
            case GeolocationAndroidPlayServices.versionUpdateRequired:
            case GeolocationAndroidPlayServices.disabled:
            case GeolocationAndroidPlayServices.invalid:
          }
          break;
      }
    }
  }
}
