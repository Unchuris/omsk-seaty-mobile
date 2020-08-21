import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/data/models/complain_type.dart';

import '../list_provider.dart';

class CheckBoxList extends StatefulWidget {
  CheckBoxList() : super();

  @override
  State<StatefulWidget> createState() => _CheckBoxListState();
}

class _CheckBoxListState extends State<CheckBoxList> {
  @override
  Widget build(BuildContext context) {
    var provider = ListProvider.of(context);
    return Container(
      width: 280,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: provider.list.keys.map((Object key) {
          return CheckboxListTile(
            title: Text(_getNameOfObject(key)),
            value: provider.list[key],
            activeColor: Colors.orange,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool value) {
              setState(() =>
                  {provider.list[key] = value, print(_getNameOfObject(key))});
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
