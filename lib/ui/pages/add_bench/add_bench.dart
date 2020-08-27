import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/add_photo_for_bench.dart';

import 'stepper.dart';

class AddBenchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBenchState();
}

class _AddBenchState extends State<AddBenchScreen> {
  int _currentStep = 0;
  List<BenchStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      BenchStep(
          title: "Add information",
          body: AddPhotoScreen(onNextButton: _nextStep)),
      BenchStep(title: "Add information", body: Container()),
      BenchStep(title: "Add information", body: Container()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add bench')), body: _buildStepper(context));
  }

  Widget _buildStepper(BuildContext context) {
    return WillPopScope(
        child: BenchMaterialStepper(currentStep: _currentStep, steps: _steps),
        onWillPop: () async {
          if (_currentStep != 0) {
            setState(() {
              _currentStep--;
            });
            return false;
          }
          return true;
        });
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }
}
