
import 'package:flutter/widgets.dart';
import 'package:workcheckapp/models/response_model.dart';
import 'package:workcheckapp/models/user_model.dart';
import 'package:workcheckapp/services/api.dart';
import 'package:workcheckapp/services/modals.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/utils.dart';


class UserProvider extends ChangeNotifier {
  UserModel? _user;

  Future<UserModel?> getMe(BuildContext context) async {
    try {
      final response = await Api.getMe();
      if (response == null || response.isEmpty) {
        return null;
      }
      final res = Response.fromJson(response);
      if (res.code == 200) {
        final data = response['data']; 
        _user = UserModel.fromJson(data);
        await Utils.setUser(_user);
        notifyListeners();
        return _user;
      } else{
        showSnackBar(context, res.message);
      }
    } catch (e) {
      debugPrint('Error in getMe: $e');
      if (e.toString() == "Gateway timeout.") {
        Modals.gatewayConnectionTimeout(context);
      }
      throw e;
    }
    return null;
  }
}
