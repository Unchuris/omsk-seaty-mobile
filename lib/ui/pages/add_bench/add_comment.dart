import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/ui/widgets/start_rating.dart';

class AddCommentStep extends StatefulWidget {
  AddCommentStep({
    Key key,
  }) : super(key: key);

  @override
  _AddCommentStepState createState() => _AddCommentStepState();
}

class _AddCommentStepState extends State<AddCommentStep> {
  int rating = 0;
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _buildComment();
  }

  Widget _buildComment() {
    return Stack(
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
                        style: Theme.of(context).textTheme.button),
                    onPressed: () {}),
              ),
            ),
          ),
        ),
      ],
    );
  }

  setReting(int rate) {
    setState(() {
      rating = rate;
    });
  }
}
