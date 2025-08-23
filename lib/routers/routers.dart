import 'package:flutter/material.dart';
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
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AttendancePage(),
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
      return MaterialPageRoute(
        settings: settings,
        builder:(_)=>FaceDetectorPage());
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
