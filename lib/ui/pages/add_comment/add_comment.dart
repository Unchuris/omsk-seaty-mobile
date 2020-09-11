import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';
import 'package:omsk_seaty_mobile/ui/widgets/start_rating.dart';
import 'package:omsk_seaty_mobile/http.dart';

class AddCommentPage extends StatefulWidget {
  AddCommentPage({Key key, this.benchId, this.onAdd}) : super(key: key);
  Function onAdd;
  final String benchId;
  static String routeName = '/addComment';
  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  int rating = 0;
  final myController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return _buildComment();
  }

  final _formKey = GlobalKey<FormState>();
  Widget _buildComment() {
    return Scaffold(
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('string_add_comment')),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: StatefulStarRating(
                      rating: rating,
                      onChange: setReting,
                    ))),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: myController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        myController.clear();
                        return AppLocalizations.of(context)
                            .translate("validate_textfield");
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    maxLength: 250,
                    cursorColor: Color(0xffF2994A),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 16.0, right: 16.0),
                        labelStyle: Theme.of(context).textTheme.subtitle1,
                        helperStyle: Theme.of(context).textTheme.subtitle2,
                        labelText: AppLocalizations.of(context)
                            .translate('string_add_comment_label_text'),
                        helperText: AppLocalizations.of(context)
                            .translate('string_add_comment_helper_text')),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 14.0),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(24),
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                        AppLocalizations.of(context).translate('string_add'),
                        style: Theme.of(context).textTheme.button),
                    onPressed: () async {
                      if (rating == 0) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)
                                  .translate("validate_raing")),
                              Icon(Icons.error)
                            ],
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                      if (rating > 0) {
                        try {
                          var responce = await dio.post('/comments/', data: {
                            'bench_id': widget.benchId,
                            'text': myController.text,
                            'rating': rating
                          });
                          widget.onAdd();
                          Navigator.pop(context);
                        } on DioError catch (e) {
                          if (e.response.statusCode == 405) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Вы уже комментировали даннулю лавочку.'),
                                  Icon(Icons.error)
                                ],
                              ),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Проблемы с соединением,повторите попытку.'),
                                  Icon(Icons.error)
                                ],
                              ),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setReting(int rate) {
    setState(() {
      rating = rate;
    });
  }
}
