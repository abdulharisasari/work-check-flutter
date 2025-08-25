import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/models/user_model.dart';
import 'package:workcheckapp/providers/user_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/db_local.dart';
import 'package:workcheckapp/services/snack_bar.dart';

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
    final localDb = LocalOfflineDatabase<UserModel>(
      boxName: 'user_offline',
      fromJson: (json) => UserModel.fromJson(json),
      toJson: (user) => user.toJson(),
    );

    UserModel? user;

    try {
      final offlineUser = await localDb.getLatestItem();

      if (offlineUser != null) {
        user = offlineUser;
        Navigator.of(context).pushNamedAndRemoveUntil(attendanceRoute, (route) => false);
      }

      final serverUser = await userProv.getMe(context).timeout(const Duration(seconds: 2));

      if (serverUser != null) {
        user = serverUser;

        await localDb.clearAll();
        await localDb.addItem(serverUser);

        Navigator.of(context).pushNamedAndRemoveUntil(attendanceRoute, (route) => false);
      } else if (user == null) {
        throw Exception("Please login!");
      }
    } catch (e) {
      if (user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
        final message = e is Exception ? e.toString() : "Terjadi kesalahan, silakan login ulang.";
        showSnackBar(context, message);
      } else {
        debugPrint("Error mengambil data server, tetap pakai local: $e");
      }
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
