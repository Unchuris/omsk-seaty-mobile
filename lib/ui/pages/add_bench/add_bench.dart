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
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(title: Text('Add bench')),
            body: _buildStepper(context)),
        onWillPop: () async {
          BlocProvider.of<AddImageBloc>(context).add(AddImageCanceled());
          return true;
        });
  }

  Widget _buildStepper(BuildContext context) {
    return AddBenchStepper(
      steps: [
        _buildAddImageStep(context),
        AddBenchStep(
            isActive: false,
            title: Text('Add information'),
            content: Center(
                child: Text('Second step',
                    style: TextStyle(color: Colors.black)))),
        AddBenchStep(
            title: Text('Star bench'),
            content: Center(
                child:
                    Text('Third step', style: TextStyle(color: Colors.black))))
      ],
      onStepTapped: (index) {
        setState(() {
          _index = index;
        });
      },
      currentStep: _index,
    );
  }

  _buildAddImageStep(BuildContext context) {
    return AddBenchStep(
        title: Text('Add photo'),
        content: AddPhotoScreen(
            onNextButton: () => {
                  setState(() {
                    _index++;
                  })
                }));
  }
}
