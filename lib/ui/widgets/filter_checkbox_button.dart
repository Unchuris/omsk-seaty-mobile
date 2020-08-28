import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/check_box_list/check_box_list_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';

enum TypeCheckBox { withButton, oneState, checkBox }

class FilterCheckBox extends StatefulWidget {
  final TypeCheckBox type;
  final BenchType benchType;
  final String title;
  final Widget icon;
  final int color;
  final Map<BenchType, bool> benches;
  bool isSelected;
  Function onPressed;
  Function(bool isSelected) onCheckChanged;

  FilterCheckBox(
      {Key key,
      this.type,
      this.benchType,
      this.color,
      this.icon,
      this.title,
      this.isSelected,
      this.onCheckChanged,
      this.onPressed,
      this.benches})
      : super(key: key);

  @override
  _FilterCheckBoxState createState() => _FilterCheckBoxState();
}

class _FilterCheckBoxState extends State<FilterCheckBox> {
  bool _isSelected;
  @override
  Widget build(BuildContext context) {
    Widget filter;
    _isSelected = widget.isSelected;
    switch (widget.type) {
      case TypeCheckBox.oneState:
        filter = Container(
          width: 200,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Color(0x1A000000 + widget.color),
          ),
          child: Row(
            children: [
              Container(
                width: 25.0,
                height: 18.0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 2.0,
                      left: 5.0,
                      child: Container(
                        width: 13.0,
                        height: 13.0,
                        decoration: BoxDecoration(
                            color: Color(0xff000000 + widget.color),
                            shape: BoxShape.circle),
                      ),
                    ),
                    Positioned(
                      left: 5.0,
                      child: SizedBox(
                          width: 16.0, height: 18.0, child: widget.icon),
                    ),
                  ],
                ),
              ),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
        );
        break;
      case TypeCheckBox.checkBox:
        filter = GestureDetector(
          onTap: () {
            setState(() {
              _isSelected = !_isSelected;
            });
            widget.isSelected = _isSelected;
            widget.onCheckChanged(_isSelected);
          },
          child: Opacity(
            opacity: (_isSelected) ? 1 : 0.6,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Color(0x1A000000 + widget.color),
              ),
              child: Row(
                children: [
                  Container(
                    width: 25.0,
                    height: 18.0,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 2.0,
                          left: 5.0,
                          child: Container(
                            width: 13.0,
                            height: 13.0,
                            decoration: BoxDecoration(
                                color: Color(0xff000000 + widget.color),
                                shape: BoxShape.circle),
                          ),
                        ),
                        Positioned(
                          left: 5.0,
                          child: SizedBox(
                              width: 16.0, height: 18.0, child: widget.icon),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case TypeCheckBox.withButton:
        filter = Container(
          width: 240,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Color(0x1A000000 + widget.color),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 9.0,
                left: 4.0,
                child: Container(
                  width: 13.0,
                  height: 13.0,
                  decoration: BoxDecoration(
                      color: Color(0xff000000 + widget.color),
                      shape: BoxShape.circle),
                ),
              ),
              Positioned(
                top: 7,
                left: 5.0,
                child: SizedBox(width: 16.0, height: 18.0, child: widget.icon),
              ),
              Positioned(
                top: 6.0,
                left: 29.0,
                bottom: 4.0,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Opacity(
                  opacity: 0.9,
                  child: SizedBox(
                    width: 22,
                    height: 20,
                    child: RawMaterialButton(
                      onPressed: () {
                        BlocProvider.of<CheckBoxListBloc>(context)
                            .add(CheckBoxItemDelete(item: widget.benchType));
                      },
                      child: Icon(
                        Icons.close,
                        size: 16.0,
                        color: Color(0x1A000000 + widget.color),
                      ),
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      default:
    }
    return filter;
  }
}
