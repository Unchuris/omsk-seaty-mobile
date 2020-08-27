import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/check_box_list/check_box_list_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/data/models/complain_type.dart';

class CheckBoxList extends StatefulWidget {
  final Map<Object, bool> map;
  CheckBoxList(this.map) : super();

  @override
  State<StatefulWidget> createState() => _CheckBoxListState();
}

class _CheckBoxListState extends State<CheckBoxList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: widget.map.keys.map((Object key) {
          return CheckboxListTile(
            title: Text(_getNameOfObject(key)),
            value: widget.map[key],
            activeColor: Colors.orange,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool value) {
              setState(() => {
                    widget.map[key] = value,
                    BlocProvider.of<CheckBoxListBloc>(context)
                        .add(CheckBoxListChanged(widget.map))
                  });
            },
          );
        }).toList(),
      ),
    );
  }

  String _getNameOfObject(Object object) {
    if (object is BenchType) return benchTypeToString(object, context);
    if (object is ComplainType) return complaintTypeToString(object, context);
  }
}
