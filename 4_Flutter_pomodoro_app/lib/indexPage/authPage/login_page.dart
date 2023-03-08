//dart 기본 패키지
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//dart 로그인 패키지
import 'package:flutterfire_ui/auth.dart';

//dart 다른 index
import 'package:pomodoro_timer/indexPage/third_page.dart';


class loginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SignInScreen(providerConfigs: [
      EmailProviderConfiguration()
    ]);
  }
}
