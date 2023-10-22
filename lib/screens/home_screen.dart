import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:win_app_fyp/services/auth_service.dart';
import 'package:win_app_fyp/themes/colors.dart';
import 'package:win_app_fyp/widgets/common/main_btn.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();

  String _healthStatus = 'N/A';
  String _workLoad = 'N/A';
  List _healthTips = [];
  String _email = "";

  bool _isWorking = false;

  bool _isLoading = true;

  void _handleHealthData() async {
    _isLoading = true;

    final email = await _authService.getUserEmail();
    if (mounted) {
      setState(() {
        _email = email;
      });
    }
    final healthStatus = await _authService.getMentalStatus(email);
    final workLoad = await _authService.getWorkLoad(email);
    final healthTips = await _authService.getUserMentalHealth(email);

    setState(() {
      _isWorking = false;

      _healthStatus = healthStatus;
      _workLoad = workLoad;
      _healthTips = healthTips;
    });

    _isLoading = false;
  }

  void _handleWorkStatus(isWorking) async {

    setState(() {
      _isWorking = isWorking;
    });

    await _authService.updateWorkStatus(
        _email, isWorking ? 'Online' : 'Offline');

    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _handleHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: AppColors.secondaryColor,
            child: Center(
                child: LoadingAnimationWidget.fallingDot(
                    color: AppColors.primaryColor, size: 60)),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  WindowTitleBarBox(
                    child: Row(
                      children: [
                        Expanded(child: MoveWindow()),
                        Row(
                          children: [
                            MinimizeWindowButton(),
                            // MaximizeWindowButton(),
                            !_isWorking ? CloseWindowButton() : const SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                  _isWorking
                      ? Image.asset('images/win1.png')
                      : Image.asset('images/win2.png'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 60),
                    child: _isWorking
                        ? MainBtn(
                            title: 'Stop Work',
                            btnColor: AppColors.errorColor,
                            onPressed: () {
                              _handleWorkStatus(false);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Work stopped!"),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                            },
                            txtColor: AppColors.textColorDark,
                          )
                        : MainBtn(
                            title: 'Start Work',
                            btnColor: AppColors.primaryColor,
                            onPressed: () {
                              _handleWorkStatus(true);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("You are now Online!"),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                            },
                            txtColor: AppColors.textColorDark,
                          ),
                  ),
                  !_isWorking
                      ? TextButton(
                          onPressed: () {
                            _authService.logout(context);
                          },
                          child: const Text("Logout"))
                      : const SizedBox(),
                ],
              ),
            ),
          );
  }
}
