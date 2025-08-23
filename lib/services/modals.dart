import 'package:flutter/material.dart';
import 'package:workcheckapp/modals/gateway_connection.dart';
import 'package:workcheckapp/modals/maps/access_location.dart';
import 'package:workcheckapp/modals/maps/access_permission.dart';
import 'package:workcheckapp/services/themes.dart';



const Curve curve = Curves.easeInOut;
const Duration duration = const Duration(milliseconds: 00);

class Modals {
  static Future<void> gatewayConnectionTimeout(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return GatewayConnectionModal();
      },
      enableDrag: false,
    );
  }

  static Future<void> accessLocation(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return AccessLocationModal();
      },
      enableDrag: false,
    );
  }

  static Future<void> accessPermission(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return AccessPermissionModal();
      },
      enableDrag: false,
    );
  }
  
  static Future<T?> showBottomSheet<T>({required BuildContext context, required Widget child, required double scrollControlDisabledMaxHeightRatio}) async {
    final result = await showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: height(context) * .8,
          width: width(context),
          child: SingleChildScrollView(child: child),
        );
      },
    );
    return result;
  }
}
