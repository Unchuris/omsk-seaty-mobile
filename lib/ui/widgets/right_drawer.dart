import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';

import '../../app_localizations.dart';

class FilterDrawer extends StatefulWidget {
  final Set<FilterType> filters;

  const FilterDrawer({Key key, this.filters}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  List<FilterType> get _filters => widget.filters.toList() ?? List();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 75.0, left: 16.0),
              child: Text(
                AppLocalizations.of(context).translate('bench_filter'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75.0, right: 16.0),
              child: IconButton(
                  icon: SvgPicture.asset("assets/union.svg"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
        ..._getFilters(_filters, context),
        Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: Center(
            child: ButtonTheme(
              minWidth: 209,
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Color(0xffF2994A),
                child: Text(AppLocalizations.of(context).translate('find'),
                    style: Theme.of(context).textTheme.headline6),
                onPressed: () {
                  //TODO добавить проверку, что список не поменялся
                  BlocProvider.of<MapBloc>(context)
                      .add(OnFilterChangedEvent(filterTypes: _filters.toSet()));
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        )
      ],
    )));
  }

  List<Widget> _getFilters(List<FilterType> filters, BuildContext context) {
    List<Widget> list = [];
    for (FilterType filterType in filters) {
      list.add(Container(
        width: 220,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: _getFilterCheckBox(filterType)),
      ));
    }
    return list;
  }

  _updateFilter(FilterType filterType, bool isSelected) {
    filterType.enable = isSelected;
  }

  // ignore: missing_return
  FilterCheckBox _getFilterCheckBox(FilterType filterType) {
    var title = benchTypeToString(filterType.benchType, context);
    switch (filterType.benchType) {
      case BenchType.HIGH_COMFORT:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0xF2C94C,
            icon: SvgPicture.asset("assets/filter_park.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
      case BenchType.URN_NEARBY:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0xF2994A,
            icon: SvgPicture.asset("assets/trashсan.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
      case BenchType.TABLE_NEARBY:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0xEB5757,
            icon: SvgPicture.asset("assets/table.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
      case BenchType.COVERED_BENCH:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0xBB6BD9,
            icon: SvgPicture.asset("assets/warn.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
      case BenchType.FOR_A_LARGE_COMPANY:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0x2F80ED,
            icon: SvgPicture.asset("assets/bitgroup.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
      case BenchType.SCENIC_VIEW:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0x219653,
            icon: SvgPicture.asset("assets/beautifulPlase.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
      case BenchType.BUS_STOP:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.checkBox,
            color: 0x5856D6,
            icon: SvgPicture.asset("assets/busstop.svg"),
            isSelected: filterType.enable,
            onCheckChanged: (isSelected) =>
                _updateFilter(filterType, isSelected));
    }
  }
}
