
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workcheckapp/configs/env.dart';
import 'package:workcheckapp/services/enums.dart';
import 'package:workcheckapp/services/utils.dart';




const headers = {
  'Content-Type': 'application/json'
};

const String gatewayTimeOutText = 'Gateway timeout.';
const String maskingErrorText = 'There are some issues with the network or system. Please try again for a while.';

class ResponseApi {
  final int statusCode;
  final String jsonString;

  const ResponseApi({
    required this.statusCode,
    required this.jsonString,
  });
}

Future<ResponseApi> _getResponseApi(
  HttpMethod method,
  String path, {
  String? body,
  String? authorization,
  String? appVersion,
  bool? export,
  bool useEndpoint = true,
  BaseURL baseUrl = BaseURL.NPM,
}) async {
  try {
    final env = await Env.getEnv();

    final SecurityContext context = SecurityContext();

    final HttpClient httpClient = HttpClient(
      context: baseUrl == BaseURL.NPM ? context : null,
    );

    httpClient.badCertificateCallback = (cert, host, port) {
      return baseUrl == BaseURL.NPM ? false : true;
    };

    String responseString = '', uri = '';
    late HttpClientRequest request;
    HttpClientResponse? response;

    switch (baseUrl) {
      case BaseURL.GMAPS:
        uri = env.apiGoogleMapsBaseUrl! + path;
        break;
      case BaseURL.CUSTOM:
        uri = path;
        break;
      default:
        uri = useEndpoint ? env.apiEndPoint! + path : env.baseUrl! + path;
    }

    final url = Uri.parse(uri);
    final tokenFCM = await Utils.getTokenFCM() ?? '';

    final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final pref = await SharedPreferences.getInstance();
    if (path.split('?')[0].contains('signature')) {
      pref.setInt('timestamp', timestamp);
    }

    switch (method) {
      case HttpMethod.get:
        request = await httpClient.getUrl(url);
        request.headers.contentType = ContentType.json;
        if (authorization != null) request.headers.add('authorization', authorization);
        if (export != null) request.headers.add('export', export);
        if (appVersion != null) request.headers.add('version', appVersion);
        if (body != null) {
          request.headers.contentLength = utf8.encode(body).length;
          request.add(utf8.encode(body));
        }
        break;
      case HttpMethod.post:
        request = await httpClient.postUrl(url);
        request.headers.contentType = ContentType.json;
        if (baseUrl == BaseURL.CUSTOM) {
          request.headers.add('x-nagopos-token', tokenFCM);
        }
        if (appVersion != null) request.headers.add('version', appVersion);
        if (authorization != null) request.headers.add('authorization', authorization);
        if (export != null) request.headers.add('export', export);

        if (body != null) request.add(utf8.encode(body));
        break;
      case HttpMethod.put:
        request = await httpClient.putUrl(url);
        request.headers.contentType = ContentType.json;
        if (baseUrl == BaseURL.CUSTOM) {
          request.headers.add('x-nagopos-token', tokenFCM);
        }
        if (authorization != null) request.headers.add('authorization', authorization);
        if (export != null) request.headers.add('export', export);
        if (body != null) request.add(utf8.encode(body));
        break;
      case HttpMethod.delete:
        request = await httpClient.deleteUrl(url);
        request.headers.contentType = ContentType.json;
        if (baseUrl == BaseURL.CUSTOM) {
          request.headers.add('x-nagopos-token', tokenFCM);
        }
        if (authorization != null) request.headers.add('authorization', authorization);
        if (export != null) request.headers.add('export', export);
        if (body != null) request.add(utf8.encode(body));
        break;
      case HttpMethod.patch:
        request = await httpClient.patchUrl(url);
        request.headers.contentType = ContentType.json;
        if (baseUrl == BaseURL.CUSTOM) {
          request.headers.add('x-nagopos-token', tokenFCM);
        }
        if (authorization != null) request.headers.add('authorization', authorization);
        if (export != null) request.headers.add('export', export);
        if (body != null) request.add(utf8.encode(body));
        break;
      default:
        break;
    }

    response = await request.close();
    await for (var val in response.transform(utf8.decoder)) {
      responseString += val;
    }

    if (response.statusCode != 200) {
      Sentry.captureMessage(
        'Error HTTP Request',
        level: SentryLevel.warning,
        params: [
          url,
          body,
          response.statusCode,
          responseString
        ],
        withScope: (scope) => scope.setTag(
          'code',
          '${response!.statusCode}',
        ),
      );
    }

    return ResponseApi(
      jsonString: responseString,
      statusCode: response.statusCode,
    );
  } catch (e, stacktrace) {
    Sentry.captureException(e, stackTrace: stacktrace);
    if (e is SocketException) {
      throw gatewayTimeOutText;
    } else if (e is HandshakeException)
      throw '$gatewayTimeOutText. please update to the latest version';
    else if (e is HttpException) throw maskingErrorText;
    throw e;
  }
}


class Api {

  static Future<Map<String, dynamic>?> login(String body) async {
    try {
      final response = await _getResponseApi(
        HttpMethod.post,
        '/auth/login',
        body: body,
      );
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      debugPrint("loginstatus ${response.statusCode}");
      if (response.statusCode == 200) return jsonDecoded;
      if (response.statusCode == 500)
        return jsonDecoded;
      else
        throw jsonDecoded!['message'];
    } catch (e) {
      if (e is FormatException) throw maskingErrorText;
      throw e;
    }
  }

  static Future<Map<String, dynamic>?> getMe() async {
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.get,
        '/auth/profile',
        authorization: token?.accessToken,
        
      );
      debugPrint("resProfile ${response.jsonString}");
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      if (response.statusCode == 200) return jsonDecoded;
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      throw e;
    }
  }

  static Future<Map<String, dynamic>?> getAttandance({String? sort}) async{
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.get,
        '/report/attendance${sort != null ? '?sort=$sort' : ''}',
        authorization: token?.accessToken,
      );
      debugPrint("resAttendance ${response.jsonString}");
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      if (response.statusCode == 200) {
        return jsonDecoded;
      } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 426) {
        debugPrint('jsonDecoded 401-403-426 on Throw $jsonDecoded');
        return jsonDecoded;
      } else
        debugPrint('jsonDecoded on Throw $jsonDecoded');
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      if (e is FormatException) {
        debugPrint('Format Exception: $e');
      } else {
        debugPrint('API call getAttandance  error: $e');
      }
    }
    return null;
  }

  
  static Future<Map<String, dynamic>?> postCreateAttendance(String body) async {
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.post,
        '/report/attendance',
        body: body,
        authorization: token?.accessToken,
      );
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      debugPrint("postAttendance status ${response.statusCode}");
      if (response.statusCode == 200)
        return jsonDecoded;
      else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 426) {
        debugPrint('jsonDecoded 401-403-426 on Throw $jsonDecoded');
        return jsonDecoded;
      } else
        debugPrint('jsonDecoded on Throw $jsonDecoded');
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      if (e is FormatException) {
        debugPrint('Format Exception: $e');
      } else {
        debugPrint('API call postCreateAttendance error: $e');
      }
    }
    return null;
  }



  static Future<Map<String, dynamic>?> getAllOutlet({String? search}) async {
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.get,
        '/stores${search != null ? '?search=$search' : ''}',
        authorization: token?.accessToken,
      );
      debugPrint("resAttendance ${response.jsonString}");
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      if (response.statusCode == 200) {
        return jsonDecoded;
      } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 426) {
        debugPrint('jsonDecoded 401-403-426 on Throw $jsonDecoded');
        return jsonDecoded;
      } else
        debugPrint('jsonDecoded on Throw $jsonDecoded');
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      if (e is FormatException) {
        debugPrint('Format Exception: $e');
      } else {
        debugPrint('API call getAllOutlet  error: $e');
      }
    }
    return null;
  }

   static Future<Map<String, dynamic>?> getDetailOutlet(int id) async {
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.get,
        '/stores$id',
        authorization: token?.accessToken,
      );
      debugPrint("resAttendance ${response.jsonString}");
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      if (response.statusCode == 200) {
        return jsonDecoded;
      } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 426) {
        debugPrint('jsonDecoded 401-403-426 on Throw $jsonDecoded');
        return jsonDecoded;
      } else
        debugPrint('jsonDecoded on Throw $jsonDecoded');
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      if (e is FormatException) {
        debugPrint('Format Exception: $e');
      } else {
        debugPrint('API call getDetailOutlet  error: $e');
      }
    }
    return null;
  }


  static Future<Map<String, dynamic>?> getProduct(String id, {String? search}) async {
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.get,
        '/stores/$id/products${search != null ? '?search=$search' : ''}',
        authorization: token?.accessToken,
      );
      debugPrint("getProduct ${response.jsonString}");
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      if (response.statusCode == 200) {
        return jsonDecoded;
      } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 426) {
        debugPrint('jsonDecoded 401-403-426 on Throw $jsonDecoded');
        return jsonDecoded;
      } else
        debugPrint('jsonDecoded on Throw $jsonDecoded');
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      if (e is FormatException) {
        debugPrint('Format Exception: $e');
      } else {
        debugPrint('API call getProduct  error: $e');
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postProductSelect(String body) async {
    try {
      final token = await Utils.getToken();
      final response = await _getResponseApi(
        HttpMethod.post,
        '/report/attendance',
        body: body,
        authorization: token?.accessToken,
      );
      final Map<String, dynamic>? jsonDecoded = jsonDecode(response.jsonString);
      debugPrint("postAttendance status ${response.statusCode}");
      if (response.statusCode == 200)
        return jsonDecoded;
      else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 426) {
        debugPrint('jsonDecoded 401-403-426 on Throw $jsonDecoded');
        return jsonDecoded;
      } else
        debugPrint('jsonDecoded on Throw $jsonDecoded');
      throw jsonDecoded?['message'] ?? 'Unknown error';
    } catch (e) {
      if (e is FormatException) {
        debugPrint('Format Exception: $e');
      } else {
        debugPrint('API call postCreateAttendance error: $e');
      }
    }
    return null;
  }



}
