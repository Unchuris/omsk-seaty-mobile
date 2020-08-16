import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StarWidget extends StatelessWidget {
  final double rate;
  const StarWidget({Key key, this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < 5; i++) {
      if (i < rate.floor()) {
        list.add(SizedBox(
            width: 12.0,
            height: 12.0,
            child: SvgPicture.asset("assets/rate.svg")));
        list.add(SizedBox(
          width: 2.0,
          height: 12.0,
        ));
      } else {
        list.add(SizedBox(
            width: 12.0,
            height: 12.0,
            child: SvgPicture.asset("assets/unrate.svg")));
        list.add(SizedBox(
          width: 2.0,
          height: 12.0,
        ));
      }
    }
    return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: [
          Text(
            rate.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: 2.0,
            height: 12.0,
          ),
          ...list,
        ]);
  }
}
