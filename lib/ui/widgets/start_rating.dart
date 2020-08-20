import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final Widget filledStar;
  final Widget unfilledStar;

  const StarRating({
    Key key,
    this.onChanged,
    this.value = 0,
    this.filledStar,
    this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).accentColor;
    final size = 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: onChanged != null
              ? () {
                  onChanged(value == index + 1 ? index : index + 1);
                }
              : null,
          color: index < value ? color : null,
          iconSize: size,
          icon: (index < value) //
              ? filledStar
              : unfilledStar,
          padding: EdgeInsets.zero,
          tooltip: '${index + 1} of 5',
        );
      }),
    );
  }
}

class StatefulStarRating extends StatelessWidget {
  int rating;
  Function(int) onChange;
  StatefulStarRating({this.rating, this.onChange});
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return StarRating(
          unfilledStar: SvgPicture.asset(
            "assets/start.svg",
            color: Color(0xffE0E0E0),
          ),
          filledStar: SvgPicture.asset(
            "assets/start.svg",
            color: Color(0xffF2C94C),
          ),
          onChanged: (index) {
            setState(() {
              rating = index;
              onChange(rating);
            });
          },
          value: rating,
        );
      },
    );
  }
}
