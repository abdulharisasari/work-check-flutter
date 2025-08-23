import 'package:workcheckapp/configs/env.prod.dart' as prod;
import 'package:workcheckapp/configs/env.dev.dart' as dev;
import 'package:shared_preferences/shared_preferences.dart';

class EnvArgument {
  final String? baseUrl,
      apiEndPoint,
      optionEndPoint,
      clientId,
      clientSecret,
      apiGoogleMapsBaseUrl,
      googleMapsApiKey,
      afKey,
      androidId,
      iosId;

  const EnvArgument({
    this.baseUrl,
    this.apiEndPoint,
    this.optionEndPoint,
    this.clientId,
    this.clientSecret,
    this.apiGoogleMapsBaseUrl,
    this.googleMapsApiKey,
    this.afKey,
    this.androidId,
    this.iosId,
  });
}

class Env {
  static Future<EnvArgument> getEnv() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString('env');

    if (result == null || result == 'Production') {
      return EnvArgument(
        baseUrl: prod.BASE_URL,
        apiEndPoint: prod.API_ENDPOINT,
        clientId: prod.CLIENT_ID,
        clientSecret: prod.CLIENT_SECRET,
        apiGoogleMapsBaseUrl: prod.GMAPS_BASE_URL,
        googleMapsApiKey: prod.GOOGLE_MAPS_API_KEY,
        afKey: prod.AF_KEY,
        androidId: prod.ANDROID_ID,
        iosId: prod.IOS_ID,
      );
    } 
    else {
      return 
      EnvArgument(
        baseUrl: dev.BASE_URL,
        apiEndPoint: dev.API_ENDPOINT,
        clientId: dev.CLIENT_ID,
        clientSecret: dev.CLIENT_SECRET,
        apiGoogleMapsBaseUrl: dev.GMAPS_BASE_URL,
        googleMapsApiKey: dev.GOOGLE_MAPS_API_KEY,
        afKey: dev.AF_KEY,
        androidId: dev.ANDROID_ID,
        iosId: dev.IOS_ID,
      );
    }
  }
}
