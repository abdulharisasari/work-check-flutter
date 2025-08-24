import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workcheckapp/models/auth_model.dart';
import 'package:workcheckapp/models/user_model.dart';

class Utils {
    static Future<void> setToken(AuthModel auth) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'accesstoken', value: auth.accessToken ?? '');
    await storage.write(key: 'refreshtoken', value: auth.refreshToken ?? '');
    await storage.write(key: 'grant', value: "GRANTED");
  }

  static Future<String?> getTokenFCM() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'tokenFCM');
    return token;
  }

  static List<BoxShadow> shadowCustom({Color color = Colors.black12, double blur = 8, double spread = 0, Offset offset = const Offset(0, 8)}) {
    return [
      BoxShadow(color: color, blurRadius: blur, spreadRadius: spread, offset: offset)
    ];
  }

  static Future<AuthModel?> getToken() async {
    final storage = FlutterSecureStorage();
    try {
      String? accessToken = await storage.read(key: 'accesstoken');
      String? refreshToken = await storage.read(key: 'refreshtoken');
      if (accessToken != null && refreshToken != null) {
        final auth = AuthModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return auth;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<void> setTokenFCM(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'tokenFCM', value: token);
  }



  static Future<void> setUser(UserModel? user) async {
    if (user != null) {
      final jsonString = jsonEncode(user.toJson());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonString);
    }
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString == null) return null;

    final userModel = UserModel.fromJson(jsonDecode(userString));
    return userModel;
  }

  static Future<void> setAuth(String isGranted) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'grant', value: isGranted);
  }

  static Future<String?> getAuth() async {
    final storage = FlutterSecureStorage();
    String? isGranted = await storage.read(key: 'grant');
    return isGranted;
  }

  static Future<void> removeToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'accesstoken');
    await storage.delete(key: 'refreshtoken');
    await storage.delete(key: 'grant');
  }
  
  static  Future<String> convertImageToSmallBase64(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return '';
    final resized = img.copyResize(image, width: 400);
    final jpg = img.encodeJpg(resized, quality: 30);
    return base64Encode(jpg);
  }
}






