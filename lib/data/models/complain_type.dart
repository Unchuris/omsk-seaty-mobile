import 'package:flutter/cupertino.dart';

import '../../app_localizations.dart';

enum ComplainType { ABSENT_BENCH, INAPPROPRIATE_CONTENT, OFFENSIVE_MATERIAL }

complaintTypeToString(ComplainType type, BuildContext context) {
  switch (type) {
    case ComplainType.ABSENT_BENCH:
      return AppLocalizations.of(context).translate('absent_bench');
    case ComplainType.INAPPROPRIATE_CONTENT:
      return AppLocalizations.of(context).translate('inappropriate_content');
    case ComplainType.OFFENSIVE_MATERIAL:
      return AppLocalizations.of(context).translate('offensive_material');
    default:
      return '';
  }
}
