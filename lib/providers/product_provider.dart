import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/models/product_model.dart';
import 'package:workcheckapp/models/response_model.dart' as Res;
import 'package:workcheckapp/providers/auth_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/api.dart';
import 'package:workcheckapp/services/snack_bar.dart';

class ProductProvider extends ChangeNotifier {
  Res.Response? mResponse;
  List<ProductModel> listProduct = [];

  Future<List<ProductModel>?> getProduct( BuildContext context, String outletId, {String? search}) async{
    try {
      final response = await Api.getProduct(outletId, search: search);
      if (response == null || response.isEmpty) {
        return null;
      }
      final _response = Res.Response.fromJson(response);
      if (_response.code == 200) {
        final List<ProductModel> data = ProductModel.fromList(response['data']);
        debugPrint('data product prov: $data');
        listProduct = data;
        return listProduct;
      } else if (_response.code == 400 || _response.code == 401 || _response.code == 403 || _response.code == 426) {
        final authProv = Provider.of<AuthProvider>(context, listen: false);
        authProv.logout(context);
        Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
        showSnackBar(context, _response.message);
        throw (_response.message);
      }
    } catch (e) {
      debugPrint('Error in getProduct: $e');
    }
    return null;
  }


  Future<Res.Response?> createProductSelect(BuildContext context, List<ProductModel> listProduct) async {
    try {
    final body = {
        "products": listProduct.map((p) => {
          "id": p.id,
          "available": p.availableStock, // confirm backend key
        }).toList(),
      };

      final jsonString = jsonEncode(body);
      print('jsonString create attendance: $jsonString');

      final response = await Api.postProductSelect(jsonString);
      if (response == null || response.isEmpty) {
        return null;
      }
      return Res.Response.fromJson(response);
    } catch (e) {
      debugPrint('Error in createProductSelectProv: $e');
    }
    return null;
  }

  
}