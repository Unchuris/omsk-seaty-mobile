import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  width: 50,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/google_logo.png',
                      height: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)
                            .translate('string_google_sign_in'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white)),
                  ),
                )
              ],
            ),
            SizedBox.expand(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoginWithGooglePressed());
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
