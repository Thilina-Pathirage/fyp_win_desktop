import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:win_app_fyp/services/auth_service.dart';
// import 'package:fyp_mobile/services/auth_services.dart';
import 'package:win_app_fyp/themes/colors.dart';
import 'package:win_app_fyp/widgets/common/main_btn.dart';
import 'package:win_app_fyp/widgets/common/main_text_input.dart';
// import 'package:fyp_mobile/widgets/main_btn.dart';
// import 'package:fyp_mobile/widgets/main_text_input.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _handleLogin() async {
    if (_validateEmail(_emailController.text) &&
        _validatePassword(_passwordController.text)) {
      try {
        await _authService.login(
            _emailController.text, _passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!",
                style: TextStyle(color: AppColors.textColorDark)),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        // Navigate to login page
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Signup failed, show error message or handle the error
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email and password is required!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(child: MoveWindow()),
                      Row(
                        children: [
                          MinimizeWindowButton(
                            colors: WindowButtonColors(
                              iconNormal: AppColors.textColorDark,
                            ),
                          ),
                          // MaximizeWindowButton(),
                          CloseWindowButton(
                              colors: WindowButtonColors(
                            iconNormal: AppColors.textColorDark,
                          ))
                        ],
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(26.0),
                                child: Column(
                                  children: [
                                    MainTxtInput(
                                        label: 'Email',
                                        obsecure: false,
                                        controller: _emailController),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    MainTxtInput(
                                        label: 'Password',
                                        obsecure: true,
                                        controller: _passwordController),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const SizedBox(
                                      height: 36,
                                    ),
                                    MainBtn(
                                      title: 'Sign In',
                                      btnColor: AppColors.primaryColor,
                                      onPressed: () async {
                                        _handleLogin();
                                      },
                                      txtColor: AppColors.textColorDark,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
