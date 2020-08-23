import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';

class Comment extends StatefulWidget {
  final UiComment comment;
  Comment({Key key, this.comment}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  double startHeight = 64.0;
  double _height;
  int _maxLine = 1;
  @override
  void initState() {
    _height = startHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_height == startHeight) {
            _height = 108.0;
            _maxLine = 5;
          } else {
            _height = startHeight;
            _maxLine = 1;
          }
        });
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        width: 343.0,
        height: _height,
        duration: Duration(microseconds: 1000),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.comment.photoUrl)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment.displayName,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      widget.comment.rank,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      widget.comment.text,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: _maxLine,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/rate.svg"),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(widget.comment.rating.toString(),
                            style: Theme.of(context).textTheme.subtitle1),
                        SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: IconButton(
                                padding: const EdgeInsets.all(0.0),
                                iconSize: 24.0,
                                icon: Icon(Icons.more_vert),
                                onPressed: null))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
