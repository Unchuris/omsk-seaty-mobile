import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/check_box_list/check_box_list_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/add_comment.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/add_information.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/add_photo_for_bench.dart';

import 'stepper.dart';

class AddBenchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBenchState();
}

class _AddBenchState extends State<AddBenchScreen> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                AppLocalizations.of(context).translate("string_add_bench"))),
        body: _buildStepper(context));
  }

  Widget _buildStepper(BuildContext context) {
    return WillPopScope(
        child:
            BenchMaterialStepper(currentStep: _currentStep, steps: <BenchStep>[
          BenchStep(
              title: AppLocalizations.of(context).translate("string_add_photo"),
              body: AddPhotoScreen(onNextButton: _nextStep)),
          BenchStep(
              title: AppLocalizations.of(context).translate("string_add_info"),
              body: AddInformationStep(
                onNextButton: _nextStep,
              )),
          BenchStep(
              title:
                  AppLocalizations.of(context).translate("string_rate_bench"),
              body: AddCommentStep()),
        ]),
        onWillPop: () async {
          if (_currentStep != 0) {
            setState(() {
              _currentStep--;
            });
            return false;
          }
          BlocProvider.of<CheckBoxListBloc>(context).add(CheckBoxClouse());
          BlocProvider.of<AddImageBloc>(context).add(AddImageCanceled());
          return true;
        });
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }
}