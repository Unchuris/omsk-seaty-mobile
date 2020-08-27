import 'package:flutter/widgets.dart';

import '../../app_localizations.dart';

enum BenchType {
  HIGH_COMFORT,
  URN_NEARBY,
  TABLE_NEARBY,
  COVERED_BENCH,
  FOR_A_LARGE_COMPANY,
  SCENIC_VIEW,
  BUS_STOP
}

benchTypeToString(BenchType type, BuildContext context) {
  switch (type) {
    case BenchType.HIGH_COMFORT:
      return AppLocalizations.of(context).translate('high_comfort');
    case BenchType.URN_NEARBY:
      return AppLocalizations.of(context).translate('urn_nearby');
    case BenchType.TABLE_NEARBY:
      return AppLocalizations.of(context).translate('table_nearby');
    case BenchType.COVERED_BENCH:
      return AppLocalizations.of(context).translate('covered_bench');
    case BenchType.FOR_A_LARGE_COMPANY:
      return AppLocalizations.of(context).translate('for_a_large_company');
    case BenchType.SCENIC_VIEW:
      return AppLocalizations.of(context).translate('scenic_view');
    case BenchType.BUS_STOP:
      return AppLocalizations.of(context).translate('bus_stop');
    default:
      return "";
  }
}

class FilterType {
  BenchType benchType;
  bool enable;

  FilterType({this.benchType, this.enable});

  @override
  bool operator == (Object o) {
    return o is FilterType && o.enable == enable && o.benchType == benchType;
  }
}

