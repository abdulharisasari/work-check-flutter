
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/models/response_model.dart' as Res;
import 'package:workcheckapp/providers/auth_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/api.dart';
import 'package:workcheckapp/services/snack_bar.dart';


class OutletProvider extends ChangeNotifier {
  Res.Response? mResponse;
  List<OutletModel> listAttendance = [];
  OutletModel outletModel = OutletModel();
  
  Future<List<OutletModel>?> getOutlet(BuildContext context,{String? search}) async {
    try {
      final response = await Api.getAllOutlet(search: search);
      if (response == null || response.isEmpty) {
        return null;
      }
      final _response = Res.Response.fromJson(response);
      if (_response.code == 200) {
        final List<OutletModel> data = OutletModel.fromList(response['data']);
        debugPrint('data outlet prov: $data');
        listAttendance = data;
        return listAttendance;
      } else if (_response.code == 400 || _response.code == 401 || _response.code == 403 || _response.code == 426) {
        final authProv = Provider.of<AuthProvider>(context, listen: false);
        authProv.logout(context);
        Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
        showSnackBar(context, _response.message);
        throw (_response.message);
      }
    } catch (e) {
      debugPrint('Error in getOutlet: $e');
    }
    return null;
  }

  Future<OutletModel?> getDetailOutlet(BuildContext context, int id) async {
    try {
      final response = await Api.getDetailOutlet(id);
      if (response == null || response.isEmpty) {
        return null;
      }
      final _response = Res.Response.fromJson(response);
      if (_response.code == 200) {
        final OutletModel data = OutletModel.fromJson(response['data']);
        debugPrint('data detail outlet prov: $data');
        outletModel = data;
        return outletModel;
      } else if (_response.code == 400 || _response.code == 401 || _response.code == 403 || _response.code == 426) {
        final authProv = Provider.of<AuthProvider>(context, listen: false);
        authProv.logout(context);
        Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
        showSnackBar(context, _response.message);
        throw (_response.message);
      }
    } catch (e) {
      debugPrint('Error in getDetailOutletProv: $e');
    }
    return null;
  }

}