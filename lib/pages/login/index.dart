import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/login_model.dart';
import 'package:workcheckapp/providers/auth_provider.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/snack_bar.dart';
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
  bool _isLoading = false;

  Future<void> performLogin() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final loginModel = LoginModel(email: emailController.text, password: passwordController.text);
    setState(() {
      _isLoading = true;
    });
    try {
      if (loginModel.email!.isEmpty || loginModel.password!.isEmpty) {
        showSnackBar(context, "Email dan Password tidak boleh kosong");
        return;
      }
      await authProv.login(context, loginModel);
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned(child: Image.asset(backgroundLoginPng)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Helloo", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(darkColor))),
                          Text("Selamat datang!", style: TextStyle(fontSize: 13, color: Color(darkColor))),
                          SizedBox(height: 150),
                          CustomTextField(label: "Username", focusNode: emailFocus, controller: emailController),
                          SizedBox(height: 20),
                          CustomTextField(label: "Password", focusNode: passwordFocus, controller: passwordController),
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
                            onPressed: () async {
                              await performLogin();
                            },
                            backgroundColor: Color(primaryColor),
                            textColor: Color(pureWhiteColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 170,
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
