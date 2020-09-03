import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';

import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/google_login_button.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          Scaffold.of(context)
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Error'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ));
        }
        if (state is AuthenticationSuccess) {
          _swithToMapScreen(context);
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print(state);
          if (state is AuthenticationInProgress ||
              state is AuthenticationSuccess) {
            return Column(
              children: [
                SizedBox(height: 10),
                CircularProgressIndicator(),
                SizedBox(height: 50),
              ],
            );
          } else {
            print('авторизация');
            return Column(
              children: <Widget>[
                GoogleLoginButton(),
                SizedBox(height: 10),
                ButtonTheme(
                  minWidth: 270,
                  height: 50,
                  child: FlatButton(
                    child: Text(
                        AppLocalizations.of(context).translate('string_skip'),
                        style: TextStyle(color: Colors.orange)),
                    onPressed: () => {
                      _swithToMapScreen(context),
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(AuthenticationSkipped())
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  void _swithToMapScreen(BuildContext context) {
    Navigator.popAndPushNamed(context, "/map");
  }
}
