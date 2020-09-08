import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/data/repositories/user_repository.dart';
import 'package:omsk_seaty_mobile/ui/pages/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset('assets/seaty_logo.svg'),
        LoginForm()
      ])),
    );
  }
}
