import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/check_box_list/check_box_list_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/childs/checkbox_list.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/dialog_with_child.dart';

import '../../../../app_localizations.dart';

class AddInformationStep extends StatefulWidget {
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
  CheckBoxListBloc _checkBoxListBloc = CheckBoxListBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('About bench', style: TextStyle(color: Colors.black))),
          Row(
            children: [
              _buildAddInformationButton(),
              BlocProvider<CheckBoxListBloc>(
                create: (context) => _checkBoxListBloc,
                child: _buildBenchesOtpions(),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildAddInformationButton() {
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
        onPressed: () {
          _checkBoxListBloc.add(CheckBoxListDialogOpened());
          showDialog(
              context: context,
              builder: (context) => BlocProvider<CheckBoxListBloc>(
                    create: (context) => _checkBoxListBloc,
                    child: DialogWithChild(
                      title: AppLocalizations.of(context)
                          .translate('dialog_title_choose'),
                      buttonText: AppLocalizations.of(context)
                          .translate('dialog_button_add'),
                      child: CheckBoxList(benches),
                      onTap: () => {
                        _checkBoxListBloc.add(CheckBoxListChanged(benches)),
                        Navigator.pop(context)
                      },
                    ),
                  ));
        },
      ),
    );
  }

  _buildBenchesOtpions() {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(left: 16),
        child: BlocProvider(
          create: (context) => _checkBoxListBloc,
          child: BlocBuilder<CheckBoxListBloc, CheckBoxListState>(
            builder: (context, state) {
              if (state is CheckBoxListDone) {
                print('changed');
                List<Widget> children = [Text('')];
                state.map.forEach((key, value) {
                  if (value == true) {
                    children.add(Text(key.toString(),
                        style: TextStyle(color: Colors.black)));
                  }
                });
                return Row(children: children);
              }
              return Text('Not done', style: TextStyle(color: Colors.black));
            },
          ),
        ));
  }
}
