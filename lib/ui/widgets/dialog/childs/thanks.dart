import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app_localizations.dart';

class ThanksChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 94, child: SvgPicture.asset('assets/seaty_logo.svg')),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context).translate('dialog_child_string'),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text(
              AppLocalizations.of(context)
                  .translate('dialog_child_status_bench'),
              style: TextStyle(fontSize: 12)),
          //SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              print("I was tapped!");
            },
            child: Text(
                AppLocalizations.of(context)
                    .translate('dialog_child_my_benches_string'),
                style: TextStyle(fontSize: 12, color: Colors.orange)),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
