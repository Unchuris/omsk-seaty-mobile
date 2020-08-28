import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/add_comment_step/add_comment_step_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/start_rating.dart';

class AddCommentStep extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  AddCommentStep({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  _AddCommentStepState createState() => _AddCommentStepState();
}

class _AddCommentStepState extends State<AddCommentStep> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return _buildComment();
  }

  final _formKey = GlobalKey<FormState>();
  Widget _buildComment() {
    return Form(
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
                  onChanged: (text) {
                    BlocProvider.of<AddCommentStepBloc>(context)
                        .add(CloseTextFieldEvent(text: text, rating: rating));
                  },
                  validator: (value) {
                    if (value.length < 8) {
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
                    onPressed: () {
                      if (rating == 0) {
                        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
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
                      if (_formKey.currentState.validate() && rating > 0) {}
                    }),
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
