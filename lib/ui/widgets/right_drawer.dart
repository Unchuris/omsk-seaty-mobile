import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';
import 'package:collection/collection.dart';

import '../../app_localizations.dart';

class FilterDrawer extends StatefulWidget {
  final FilterOptions options;
  final Set<FilterType> filters;

  const FilterDrawer({Key key, this.filters, this.options}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  FilterOptions get options => widget.options ?? FilterOptions();
  List<FilterType> get _filters => widget.filters.toList() ?? List();
  var startList = List();
  Function eq = ListEquality().equals;
  var _isChangeList = false;

  @override
  void initState() {
    startList = widget.filters
        .map((e) => FilterType(benchType: e.benchType, enable: e.enable))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          Expanded(
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(children: _getFilters(_filters, context)))),
          _buildButtonWithOpacity(
              context,
              _isChangeList ? 1 : 0.5,
              _isChangeList
                  ? () {
                      options.onFilterChanged(_filters.toSet());
                      Navigator.pop(context);
                    }
                  : () {})
        ],
      ),
    );
  }

  bool _isEqList() {
    return eq(_filters, startList);
  }

  Widget _buildButtonWithOpacity(
      BuildContext context, double opacity, Function onTap) {
    return Opacity(
        opacity: opacity,
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: RaisedButton(
                child: Text(AppLocalizations.of(context).translate('find'),
                    style: Theme.of(context).textTheme.button),
                onPressed: onTap)));
  }

  Widget _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 58.0, left: 16.0),
          child: Text(
            AppLocalizations.of(context).translate('bench_filter'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 58.0, right: 4.0),
          child: IconButton(
              icon: SvgPicture.asset("assets/union.svg"),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }

  List<Widget> _getFilters(List<FilterType> filters, BuildContext context) {
    List<Widget> list = [];
    for (FilterType filterType in filters) {
      list.add(Container(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: _getFilterCheckBox(filterType)),
      ));
    }
    return list;
  }

  _updateFilter(FilterType filterType, bool isSelected) {
    filterType.enable = isSelected;
    var updateRequired = !_isEqList();
    if (updateRequired != _isChangeList) {
      setState(() {
        _isChangeList = updateRequired;
      });
    }
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

class FilterOptions {

  final Function(Set<FilterType>) onFilterChanged;

  FilterOptions({
    this.onFilterChanged,
  });
}
