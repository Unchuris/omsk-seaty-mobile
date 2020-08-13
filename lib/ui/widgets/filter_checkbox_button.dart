import 'package:flutter/material.dart';

enum TypeCheckBox { withBox, common }

class FilterCheckBox extends StatelessWidget {
  final TypeCheckBox type;
  final String title;
  final Widget icon;
  final int color;
  const FilterCheckBox({Key key, this.type, this.color, this.icon, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Color(0x1A000000 + color),
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
                        color: Color(0xff000000 + color),
                        shape: BoxShape.circle),
                  ),
                ),
                Positioned(
                  left: 5.0,
                  child: SizedBox(width: 16.0, height: 18.0, child: icon),
                ),
              ],
            ),
          ),
          Text(
            title,
            style: TextStyle(fontFamily: "Roboto", fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
