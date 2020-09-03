import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/check_box_list/check_box_list_bloc.dart';

import 'package:omsk_seaty_mobile/blocs/stepper_storege/stepper_storage_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/childs/thanks.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/dialog_with_child.dart';
import 'package:omsk_seaty_mobile/ui/widgets/snackbar.dart';
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
    return BlocListener<StepperStorageBloc, StepperStorageState>(
      listener: (context, state) {
        if (state is ErrorState) {
          widget.scaffoldKey.currentState.showSnackBar(getSnackBarError(
              AppLocalizations.of(context)
                  .translate("network_connection_error"),
              context));
        } else if (state is SucessState) {
          _createDialogThanks(context);
        }
      },
      child: BlocBuilder<StepperStorageBloc, StepperStorageState>(
          builder: (context, state) {
        if (state is AddCommentState || state is RequestState) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is ErrorState) {}
        return _buildComment();
      }),
    );
  }

  void _createDialogThanks(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => DialogWithChild(
            title:
                AppLocalizations.of(context).translate('dialog_title_thanks'),
            buttonText:
                AppLocalizations.of(context).translate('dialog_button_good'),
            child: ThanksChild(),
            onTap: () {
              BlocProvider.of<CheckBoxListBloc>(context).add(CheckBoxClouse());
              BlocProvider.of<AddImageBloc>(context).add(AddImageCanceled());
              Navigator.popAndPushNamed(context, "/map");
            },
            buttonType: DialogButtonType.CLOSE));
  }

  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
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
                  controller: myController,
                  validator: (value) {
                    if (value.trim().isEmpty) {
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
                      if (_formKey.currentState.validate() && rating > 0) {
                        BlocProvider.of<StepperStorageBloc>(context).add(
                            AddComment(
                                rating: rating, text: myController.text));
                      }
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
