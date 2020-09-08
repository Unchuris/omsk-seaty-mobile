import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/my_benches.dart';

import '../../../../app_localizations.dart';

class ThanksChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 94, child: SvgPicture.asset('assets/seaty_logo.svg')),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context).translate('dialog_child_string'),
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline5.copyWith(fontSize: 18)),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(
                AppLocalizations.of(context)
                    .translate('dialog_child_status_bench'),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 12.0)),
            //SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MyBenchPage()),
                    ModalRoute.withName("/map")
                );
              },
              child: Text(
                  AppLocalizations.of(context)
                      .translate('dialog_child_my_benches_string'),
                  style: TextStyle(fontSize: 12, color: Colors.orange)),
            )],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
