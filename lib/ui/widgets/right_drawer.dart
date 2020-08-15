import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';

class FilterDrawer extends StatefulWidget {
  final Map<String, bool> checkBoxs;

  FilterDrawer({Key key, this.checkBoxs}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  Map<String, bool> _checkBoxs = {
    "Высокий комфорт": false,
    "Урна рядом": false,
    "Стол рядом": false,
    "Крытая лавочка": false,
    "Для большой компании": false,
    "Живописный вид": false,
    "Остановка": false
  };
  @override
  Widget build(BuildContext context) {
    //checkBoxs = widget.checkBoxs;
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
                    "Фильтр лавочек",
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
            ..._getFilters(_checkBoxs)
          ],
        ),
      ),
    );
  }

  List<Widget> _getFilters(Map<String, bool> checkBoxs) {
    List<Widget> list = [];
    checkBoxs.forEach((key, value) {
      switch (key) {
        case "Высокий комфорт":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0xF2C94C,
                icon: SvgPicture.asset("assets/filter_park.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        case "Урна рядом":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0xF2994A,
                icon: SvgPicture.asset("assets/trashсan.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        case "Стол рядом":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0xEB5757,
                icon: SvgPicture.asset("assets/table.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        case "Крытая лавочка":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0xBB6BD9,
                icon: SvgPicture.asset("assets/warn.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        case "Для большой компании":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0x2F80ED,
                icon: SvgPicture.asset("assets/bitgroup.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        case "Живописный вид":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0x219653,
                icon: SvgPicture.asset("assets/beautifulPlase.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        case "Остановка":
          list.add(Container(
            width: 220,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: FilterCheckBox(
                title: key,
                type: TypeCheckBox.checkBox,
                color: 0x5856D6,
                icon: SvgPicture.asset("assets/busstop.svg"),
                isSelected: value,
              ),
            ),
          ));
          break;
        default:
      }
    });
    return list;
  }
}
