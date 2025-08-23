import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/providers/user_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/themes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
    
  }
  void _init() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    try {
      final user = await userProv.getMe(context);
      if (user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(attendanceRoute, (route) => false);
      } else {
        throw "Please login!";
      }
    } catch (e) {
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(logoWorkCheckPng, width: 250),
      ),
    );
  }
}
