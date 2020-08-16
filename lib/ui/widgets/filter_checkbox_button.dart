import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/rightdrawer/right_draver_bloc.dart';

enum TypeCheckBox { withButton, oneState, checkBox }

class FilterCheckBox extends StatefulWidget {
  TypeCheckBox type;
  String title;
  Widget icon;
  int color;
  bool isSelected;
  FilterCheckBox(
      {Key key, this.type, this.color, this.icon, this.title, this.isSelected})
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
                      left: 2.0,
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
            if (_isSelected) {
              setState(() {
                _isSelected = false;
              });
              widget.isSelected = false;
            } else {
              setState(() {
                _isSelected = true;
              });
              widget.isSelected = true;
            }

            BlocProvider.of<RightDraverBloc>(context).add(OnFilterTapingEvent(
                title: widget.title, isTaped: widget.isSelected));
          },
          child: Opacity(
            opacity: (_isSelected) ? 1 : 0.6,
            child: Container(
              width: 140,
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
            ),
          ),
        );
        break;
      default:
    }
    return filter;
  }
}
