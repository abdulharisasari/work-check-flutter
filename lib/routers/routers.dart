import 'package:flutter/material.dart';
import 'package:workcheckapp/models/attendance_model.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/pages/attendance/camera/index.dart';
import 'package:workcheckapp/pages/attendance/index.dart';
import 'package:workcheckapp/pages/login/index.dart';
import 'package:workcheckapp/pages/outlet/detail-outlet/index.dart';
import 'package:workcheckapp/pages/outlet/index.dart';
import 'package:workcheckapp/pages/root/index.dart';
import 'package:workcheckapp/routers/constant_routers.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var uri = Uri.parse(settings.name ?? '');

    switch (uri.path) {
      case splashRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case loginRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );

      case attendanceRoute:
        final args = settings.arguments;
        AttendanceModel? attendanceModel;
        if (args != null && args is AttendanceModel) {
          attendanceModel = args;
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>  AttendancePage(attendanceModel: attendanceModel),
        );

      case outletRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OutletPage(),
        );

      case detailOutletRoute:
      final outlet = settings.arguments as OutletModel;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DetailOutletPage(outletModel: outlet),
        );
      case cameraRoute:
      final status = settings.arguments as int;
      return MaterialPageRoute(
        settings: settings,
        builder:(_)=>FaceDetectorPage(status: status));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${uri.path}'),
            ),
          ),
        );
    }
  }
}
