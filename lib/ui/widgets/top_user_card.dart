import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/data/models/complain_type.dart';
import 'package:omsk_seaty_mobile/http.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_user/model/ui_top_user.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/childs/checkbox_list.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/dialog_with_child.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/list_provider.dart';
import 'package:omsk_seaty_mobile/ui/widgets/snackbar.dart';

class TopUserCard extends StatefulWidget {
  final UiTopUser uiTopUser;
  const TopUserCard({Key key, this.uiTopUser, this.scaffoldKey})
      : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _TopUserCardState createState() => _TopUserCardState();
}

class _TopUserCardState extends State<TopUserCard> {
  Map<ComplainType, bool> _complains = {
    ComplainType.INAPPROPRIATE_CONTENT: false,
    ComplainType.OFFENSIVE_MATERIAL: false
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      width: 343.0,
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
                          widget.uiTopUser.photoUrl)),
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
                    widget.uiTopUser.displayName,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    widget.uiTopUser.rank,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Text(
                        'Лавочек',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        widget.uiTopUser.benches.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.orange),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(4.0),
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
                                      AppLocalizations.of(context)
                                          .translate("report"),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )),
                              )
                            ])),
              ],
            ),
          ),
        ],
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
          data: {"comment_id": widget.uiTopUser.id, "report_message": report});
    } on DioError catch (e) {
      if (e.response.statusCode == 405) {
        widget.scaffoldKey.currentState.showSnackBar(getSnackBarError(
            AppLocalizations.of(context).translate('already_report_bench'),
            context));
      } else if (e.response.statusCode == 403) {
        widget.scaffoldKey.currentState.showSnackBar(getSnackBarError(
            AppLocalizations.of(context).translate('403_error'), context));
      } else {
        widget.scaffoldKey.currentState.showSnackBar(getSnackBarError(
            AppLocalizations.of(context).translate("network_connection_error"),
            context));
      }
    }
  }
}
