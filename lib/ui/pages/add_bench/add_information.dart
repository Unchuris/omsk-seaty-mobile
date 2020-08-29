import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/check_box_list/check_box_list_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/stepper_storege/stepper_storage_bloc.dart';

import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/childs/checkbox_list.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/dialog_with_child.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/list_provider.dart';
import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';

class AddInformationStep extends StatefulWidget {
  final Function onNextButton;

  const AddInformationStep({this.onNextButton});
  @override
  State<StatefulWidget> createState() => _AddInformationStepState();
}

class _AddInformationStepState extends State<AddInformationStep> {
  Map<BenchType, bool> benches = {
    BenchType.TABLE_NEARBY: false,
    BenchType.COVERED_BENCH: false,
    BenchType.SCENIC_VIEW: false,
    BenchType.FOR_A_LARGE_COMPANY: false
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          AppLocalizations.of(context).translate("about_bench"),
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildAddInformationButton(context),
                    SizedBox(
                      height: 30.0,
                      width: MediaQuery.of(context).size.width * 0.87,
                      child: _buildBenchesOtpions(context),
                    )
                  ],
                ),
              ],
            ),
          ),
          _buildNextButton(context),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return BlocBuilder<CheckBoxListBloc, CheckBoxListState>(
        builder: (context, state) {
      if (state is CheckBoxListDone && state.map.containsValue(true)) {
        BlocProvider.of<StepperStorageBloc>(context)
            .add(AddFeature(features: state.map));
        return _buildButtonWithOpacity(context, 1, widget.onNextButton);
      } else if (state is CheckBoxItemChange && state.map.containsValue(true)) {
        BlocProvider.of<StepperStorageBloc>(context)
            .add(AddFeature(features: state.map));
        return _buildButtonWithOpacity(context, 1, widget.onNextButton);
      }
      return _buildButtonWithOpacity(context, 0.5, () {});
    });
  }

  Widget _buildButtonWithOpacity(
      BuildContext context, double opacity, Function onTap) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(24),
        child: MaterialButton(
          onPressed: onTap,
          child: Text(AppLocalizations.of(context).translate("string_next")),
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  _buildAddInformationButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 30,
      width: 30,
      child: RawMaterialButton(
          fillColor: Colors.orange,
          child: Icon(
            Icons.add,
            size: 24.0,
          ),
          shape: CircleBorder(),
          onPressed: _showDialog),
    );
  }

  _showDialog() {
    BlocProvider.of<CheckBoxListBloc>(context).add(CheckBoxListDialogOpened());
    showDialog(
      context: context,
      builder: (context) => ListProvider(
        benches,
        DialogWithChild(
          title: AppLocalizations.of(context).translate('dialog_title_choose'),
          buttonText:
              AppLocalizations.of(context).translate('dialog_button_add'),
          child: CheckBoxList(),
          onTap: () {
            BlocProvider.of<CheckBoxListBloc>(context)
                .add(CheckBoxListChanged(benches));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  _buildBenchesOtpions(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 16),
      child: BlocBuilder<CheckBoxListBloc, CheckBoxListState>(
        builder: (context, state) {
          List<Widget> children = [];
          if (state is CheckBoxListDone) {
            print(state.map);
            children = [];
            benches = state.map;
            benches.forEach((key, value) {
              if (value == true) {
                children.add(_getFilterCheckBox(key));
              }
            });
            return ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: children[index],
                );
              },
              scrollDirection: Axis.horizontal,
            );
          } else if (state is CheckBoxItemChange) {
            benches = state.map;
            children = [];
            benches.forEach((key, value) {
              if (value == true) {
                children.add(_getFilterCheckBox(key));
              }
            });
            return ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: children[index],
                );
              },
              scrollDirection: Axis.horizontal,
            );
          }
          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: children[index],
              );
            },
            scrollDirection: Axis.horizontal,
          );
        },
      ),
    );
  }

  FilterCheckBox _getFilterCheckBox(BenchType benchType) {
    var title = benchTypeToString(benchType, context);
    switch (benchType) {
      case BenchType.URN_NEARBY:
        return FilterCheckBox(
          benchType: BenchType.URN_NEARBY,
          title: title,
          type: TypeCheckBox.withButton,
          color: 0xF2994A,
          icon: SvgPicture.asset("assets/trashсan.svg"),
        );
      case BenchType.TABLE_NEARBY:
        return FilterCheckBox(
          benchType: BenchType.TABLE_NEARBY,
          title: title,
          type: TypeCheckBox.withButton,
          color: 0xEB5757,
          icon: SvgPicture.asset("assets/table.svg"),
        );
      case BenchType.COVERED_BENCH:
        return FilterCheckBox(
          benchType: BenchType.COVERED_BENCH,
          title: title,
          type: TypeCheckBox.withButton,
          color: 0xBB6BD9,
          icon: SvgPicture.asset("assets/warn.svg"),
        );
      case BenchType.FOR_A_LARGE_COMPANY:
        return FilterCheckBox(
          benchType: BenchType.FOR_A_LARGE_COMPANY,
          title: title,
          type: TypeCheckBox.withButton,
          color: 0x2F80ED,
          icon: SvgPicture.asset("assets/bitgroup.svg"),
        );
      case BenchType.SCENIC_VIEW:
        return FilterCheckBox(
          benchType: BenchType.SCENIC_VIEW,
          title: title,
          type: TypeCheckBox.withButton,
          color: 0x219653,
          icon: SvgPicture.asset("assets/beautifulPlase.svg"),
        );
    }
  }
}
