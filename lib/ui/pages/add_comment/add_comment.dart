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
  Function(UiComment) onAdd;
  final String benchId;
  static String routeName = '/addComment';
  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  int rating = 0;
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _buildComment();
  }

  Widget _buildComment() {
    return Scaffold(
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('string_add_comment')),
      body: Stack(
        children: [
          Positioned(
            top: 8.0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: StatefulStarRating(
                  rating: rating,
                  onChange: setReting,
                ))),
          ),
          Positioned(
            top: 60.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: myController,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                maxLength: 250,
                cursorColor: Color(0xffF2994A),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 16.0, right: 16.0),
                    labelStyle: Theme.of(context).textTheme.headline5,
                    helperStyle: Theme.of(context).textTheme.headline4,
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
          ),
          Positioned(
            bottom: 16.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ButtonTheme(
                  minWidth: 339,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffF2994A),
                    child: Text(
                        AppLocalizations.of(context).translate('string_add'),
                        style: Theme.of(context).textTheme.headline6),
                    onPressed: () async {
                      var _user =
                          BlocProvider.of<AuthenticationBloc>(context).getUser;
                      var responce = await dio.post('/comments/', data: {
                        'uid': _user.uid,
                        'bench_id': widget.benchId,
                        'text': myController.text,
                        'rating': rating
                      });
                      widget.onAdd(UiComment.fromJson(responce.data));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setReting(int rate) {
    setState(() {
      rating = rate;
    });
  }
}
