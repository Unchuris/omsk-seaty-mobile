import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';

import '../../app_localizations.dart';

class ErrorLoginPage extends StatelessWidget {
  static String routeName = "/403";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: MediaQuery.of(context).padding.top,
        title: AppLocalizations.of(context).translate('login_in'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              AppLocalizations.of(context).translate("403_error"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          RawMaterialButton(
            onPressed: () => {Navigator.pushNamed(context, "/login")},
            elevation: 8.0,
            fillColor: Theme.of(context).buttonColor,
            child: Text(
              AppLocalizations.of(context).translate("login_in"),
              style: Theme.of(context).textTheme.button,
            ),
            padding:
                EdgeInsets.only(left: 19.0, right: 19.0, top: 15, bottom: 15),
          )
        ],
      )),
    );
  }
}
