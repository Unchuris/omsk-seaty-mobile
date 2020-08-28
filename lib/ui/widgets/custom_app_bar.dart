import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const CustomAppBar({
    Key key,
    @required this.height,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: height),
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            child: IconButton(
                icon: SvgPicture.asset(
                  "assets/leftArrow.svg",
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
