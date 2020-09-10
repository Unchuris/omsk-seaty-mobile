
import 'package:flutter/material.dart';

import '../../app_localizations.dart';

Widget getRetryBlock(BuildContext context, Function onTap) {
  return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate("network_connection_error"),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            AppLocalizations.of(context).translate("check_connection_and_try_again"),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 60,
          ),
          RawMaterialButton(
            onPressed: onTap,
            elevation: 8.0,
            fillColor: Theme.of(context).buttonColor,
            child: Icon(Icons.refresh),
            padding: EdgeInsets.only(
                left: 19.0, right: 19.0, top: 15, bottom: 15),
            shape: CircleBorder(),
          )
        ],
      ));
}
