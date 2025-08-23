import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/models/attendance_model.dart';
import 'package:workcheckapp/models/response_model.dart' as Res;
import 'package:workcheckapp/providers/auth_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/api.dart';
import 'package:workcheckapp/services/snack_bar.dart';


class AttandanceProvider extends ChangeNotifier {
  Res.Response? mResponse;
  List<AttendanceModel> listAttendance =[];

  Future<List<AttendanceModel>?> getHeaderAttendance(BuildContext context, {String? sort}) async{
    try {
      final response = await Api.getAttandance(sort: sort);
      if (response == null || response.isEmpty) {
        return null;
      }
      final _response = Res.Response.fromJson(response);
      if (_response.code == 200) {
        final List<AttendanceModel> data = AttendanceModel.fromList(response['data']);
        debugPrint('data attendance prov: $data');
        listAttendance = data;
        return listAttendance;
      }else if(_response.code == 400 || _response.code == 401 || _response.code == 403 || _response.code == 426){
        final authProv = Provider.of<AuthProvider>(context, listen: false);
        authProv.logout(context);
        Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
        showSnackBar(context, _response.message);
        throw (_response.message);
      }
    } catch (e) {
      debugPrint('Error in getHeaderAttendanceProv: $e');
    }return null;
  }

  Future<Res.Response?> createAttandance(BuildContext context, AttendanceModel attendanceModel)async{
    
    try {
      final body = { ...attendanceModel.toJson()};
      final jsonString = jsonEncode(body);
      print('jsonString create attendance: ${jsonString}');
      final response = await Api.postCreateAttendance(jsonString);
      if (response == null || response.isEmpty) {
          return null;
        }
      return Res.Response.fromJson(response);
    }catch (e) {
      debugPrint('Error in createAttandanceProv: $e');
    }
    return null;
  }
  
}