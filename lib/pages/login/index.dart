import 'package:flutter/material.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/themes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Image.asset(backgroundLoginPng)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Akses Akun", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(darkColor))),
                  Text("Selamat datang!", style: TextStyle(fontSize: 13, color: Color(darkColor))),
                  SizedBox(height: 150),
                  CustomTextField(label: "Email", focusNode: emailFocus, controller: emailController),
                  SizedBox(height: 20),
                  CustomTextField(label: "Password", focusNode: passwordFocus,controller: passwordController),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Lupa Password", style: TextStyle(fontSize: 13, color: Color(darkColor))),
                    ],
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, attendanceRoute, (route) => false);
                    },
                    backgroundColor: Color(primaryColor),
                    textColor: Color(pureWhiteColor),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 170 ,
            child: Container(
              height: 70, 
              alignment: Alignment.center,
              child: Image.asset(
                logoWorkCheckPng,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
