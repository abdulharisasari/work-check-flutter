import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckapp/services/enums.dart';
import 'package:workcheckapp/services/snack_bar.dart';

class AppProvider extends ChangeNotifier {
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int _loginAttempt = 0;
  int _selectedBottomNavBar = 0;
  PageController get pageController => _pageController;

  set pageController(PageController value) {
    _pageController = value;
    notifyListeners();
  }
  int get selectedBottomNavBar => _selectedBottomNavBar;

  ServerEnvironment _serverEnvironment = ServerEnvironment.PRODUCTION;

  String get serverEnvironment {
    late String env;
    switch (_serverEnvironment) {
      case ServerEnvironment.PRODUCTION:
        env = 'Production';
        break;
      default:
        env = 'Development';
        break;
    }
    return env;
  }

  String get appVer {
    late String version;
    version = Platform.isIOS ? "1.0.1.2" : "1.0.1.1";
    return version;
  }

  bool _launchApp = false;
  bool get launchApp => _launchApp;
  set launchApp(bool value) {
    _launchApp = value;
    notifyListeners();
  }

  void selectBottomNavBar(int index) {
    _selectedBottomNavBar = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  

  void setLoginAttempt() {
    if (_loginAttempt > 2) return;
    _loginAttempt += 1;
  }

  void resetState() {
    _loginAttempt = 0;
    _selectedBottomNavBar = 0;
  }

  void changeServerEnv(BuildContext context, [bool devMode = false]) {
    late ServerEnvironment env;
    if (devMode) {
      env = ServerEnvironment.DEVELOPMENT;
    } else {
      env = ServerEnvironment.PRODUCTION;
    }
    _serverEnvironment = env;

    listener(context);
  }

  void listener(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'env',
      serverEnvironment,
    );

    final result = prefs.getString('env');

    showSnackBar(context, result ?? '-');
  }
}
