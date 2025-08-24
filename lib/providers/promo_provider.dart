import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workcheckapp/models/promo_model.dart';
import 'package:workcheckapp/models/response_model.dart' as Res;
import 'package:workcheckapp/services/api.dart';


class PromoProvider extends ChangeNotifier {
  Res.Response? mResponse;
  
   Future<Res.Response?> createProductPromo(BuildContext context, PromoModel promoModel,int outletId) async {
    try {
      final body = {...promoModel.toJson()};
      final jsonString = jsonEncode(body);
      final response = await Api.postProductPromo(jsonString,outletId );
      if (response == null || response.isEmpty) {
        return null;
      }
      return Res.Response.fromJson(response);
    } catch (e) {
      debugPrint('Error in createProductPromoProv: $e');
    }
    return null;
  }
}