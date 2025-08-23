import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workcheckapp/models/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/models/login_model.dart';
import 'package:workcheckapp/models/response_model.dart';
import 'package:workcheckapp/providers/app_provider.dart';
import 'package:workcheckapp/providers/user_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/api.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/utils.dart';

class AuthProvider with ChangeNotifier {

  
  Future<void> login( BuildContext context, LoginModel loginModel) async {
    final appProv = Provider.of<AppProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final body = { ...loginModel.toJson()};
    final jsonString = jsonEncode(body);
    try {
      final response = await Api.login(jsonString);
      debugPrint("Response login: ${jsonEncode(response)}");

      if (response != null && response['accesstoken'] != null) {
       
        final _response = Response.fromJson(response);
        final auth = AuthModel.fromJson(response);

        debugPrint("res: authAcc ${auth.accessToken}");
        debugPrint("res: authRef ${auth.refreshToken}");
        debugPrint("res: ${_response.message}");

        if (_response.code == 200) {
          try {
            await Utils.setToken(auth);
            final user = await userProv.getMe(context);
            debugPrint("user: ${user?.name}");
            if (user != null) {
               Navigator.pushNamedAndRemoveUntil(context, attendanceRoute, (route) => false) ;
              // Navigator.maybeOf(context)?.pushNamedAndRemoveUntil(attendanceRoute, (route) => false);
            } else {
              throw "User not found";
            }
          } catch (e) {
            showSnackBar(context, e.toString());
          }
        }else{
          showSnackBar(context, _response.message);
        }
      } else {
        throw "Response is null";
      }
    } catch (e) {
      if (e is String) {
        appProv.setLoginAttempt();
      }
      throw (e);
    }
  }

  Future<void> logout(BuildContext context) async {
    await Utils.removeToken();
  }
}
