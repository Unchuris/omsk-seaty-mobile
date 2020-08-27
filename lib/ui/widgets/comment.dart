import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/data/models/complain_type.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/childs/checkbox_list.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/dialog_with_child.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/list_provider.dart';
import '../../http.dart';

class Comment extends StatefulWidget {
  final UiComment comment;
  final GlobalKey<ScaffoldState> scaffoldKey;
  Comment({Key key, this.comment, this.scaffoldKey}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  double startHeight = 64.0;
  double _height;
  int _maxLine = 1;
  Map<ComplainType, bool> _complains = {
    ComplainType.ABSENT_BENCH: false,
    ComplainType.INAPPROPRIATE_CONTENT: false,
    ComplainType.OFFENSIVE_MATERIAL: false
  };

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
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset("assets/rate.svg"),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(widget.comment.rating.toString(),
                            style: Theme.of(context).textTheme.subtitle1),
                        SizedBox(
                            width: 32.0,
                            height: 12.0,
                            child: PopupMenuButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: InkWell(
                                            onTap: () {
                                              _createDialogComplain(context);
                                            },
                                            child: Text(
                                              "Пожаловаться",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            )),
                                      )
                                    ]))
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

  void _createDialogComplain(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ListProvider(
          _complains,
          DialogWithChild(
              title: AppLocalizations.of(context)
                  .translate('dialog_title_complain'),
              buttonText: AppLocalizations.of(context)
                  .translate('dialog_title_complain'),
              child: CheckBoxList(),
              onTap: onTap,
              buttonType: DialogButtonType.COMPLAIN)),
    );
  }

  onTap() async {
    var report = '';
    _complains.forEach((key, value) {
      if (value == true) {
        report = report + complaintTypeToString(key, context) + " ";
      }
    });
    Navigator.pop(context);
    try {
      var response = await dio.post("/reports/create-comment-report/",
          data: {"comment_id": widget.comment.id, "report_message": report});
    } on DioError catch (e) {
      if (e.response.statusCode == 405) {
        print("405 ошибка");
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Вы уже жаловались на этот комментарий.'),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        print("ошибка сети");
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Проблемы с соединением, повторите попытку.'),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
