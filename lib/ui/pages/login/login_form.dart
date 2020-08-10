import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/login/login_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/google_login_button.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailture) {
            Scaffold.of(context)
              ..showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Error'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ));
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationLoggedIn());
            _swithToMapScreen(context);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GoogleLoginButton(),
              SizedBox(height: 10),
              ButtonTheme(
                minWidth: 270,
                height: 50,
                child: FlatButton(
                  child: Text('Skip', style: TextStyle(color: Colors.orange)),
                  onPressed: () => _swithToMapScreen(context),
                ),
              )
            ],
          ),
        ));
  }

  void _swithToMapScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/map');
  }
}
