import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
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
  static Future<String> imageFileToBase64(File file, {int maxWidth = 500, int quality = 70}) async {
    try {
      // Step 1: Read image bytes
      final bytes = await file.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Step 2: Resize image
      final resizedImage = img.copyResize(originalImage, width: maxWidth);

      // Step 3: Encode to JPEG with quality
      final jpgBytes = img.encodeJpg(resizedImage, quality: quality);

      // Step 4: Optional further compress with flutter_image_compress
      final dir = await getTemporaryDirectory();
      final tempPath = '${dir.path}/temp.jpg';
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        tempPath,
        tempPath,
        minWidth: maxWidth,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      final finalBytes = compressedFile != null ? await compressedFile.readAsBytes() : jpgBytes;

      // Step 5: Convert to Base64
      return base64Encode(finalBytes);
    } catch (e) {
      print('Utils.imageFileToBase64 error: $e');
      return '';
    }
  }

  /// Convenience method if you have XFile from camera
  static Future<String> xFileToBase64(XFile xfile, {int maxWidth = 500, int quality = 70}) async {
    final file = File(xfile.path);
    return imageFileToBase64(file, maxWidth: maxWidth, quality: quality);
  }
  
  static Future<String> convertImageToBase64(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    return "data:image/jpeg;base64," + base64Encode(bytes);
  }
}






