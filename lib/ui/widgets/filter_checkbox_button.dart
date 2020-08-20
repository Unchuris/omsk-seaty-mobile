import 'package:flutter/material.dart';

enum TypeCheckBox { withButton, oneState, checkBox }

class FilterCheckBox extends StatefulWidget {
  final TypeCheckBox type;
  final String title;
  final Widget icon;
  final int color;
  bool isSelected;

  Function(bool isSelected) onCheckChanged;

  FilterCheckBox(
      {Key key, this.type, this.color, this.icon, this.title, this.isSelected, this.onCheckChanged})
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
            setState(() {
              _isSelected = !_isSelected;
            });
            widget.isSelected = _isSelected;
            widget.onCheckChanged(_isSelected);
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
