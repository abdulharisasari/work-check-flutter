import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/providers/app_provider.dart';
import 'package:workcheckapp/providers/auth_provider.dart';
import 'package:workcheckapp/providers/user_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/routers/routers.dart';
import 'package:workcheckapp/services/themes.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
      child: MaterialApp(
        title: 'Work Check',
       
        theme: ThemeData(
          fontFamily: 'Inter',
          primaryColor: Color(primaryColor),
          appBarTheme: appBarThemeCollapse(),
          scaffoldBackgroundColor: Color(0xFFFBFCFD),
          indicatorColor: Color(0xFFBD202E),
          textTheme: TextTheme(
            labelSmall: TextStyle(letterSpacing: 0.02, fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontWeight: FontWeight.w600),
            bodySmall: TextStyle(fontWeight: FontWeight.w600),
            titleLarge: TextStyle(fontWeight: FontWeight.w600),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(background: Color(0xFFFBFCFD)),
          bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFFBD202E)),
        ),
        initialRoute: splashRoute, 
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }

  AppBarTheme appBarThemeCollapse() {
    return AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      elevation: 0,
      color: Colors.white,
    );
  }
}

