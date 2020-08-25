import 'package:flutter/material.dart';

import 'stepper.dart';

class AddBenchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBenchState();
}

class _AddBenchState extends State<AddBenchScreen> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add bench')), body: _buildStepper(context));
  }

  Widget _buildStepper(BuildContext context) {
    return AddBenchStepper(
      steps: [
        AddBenchStep(
            isActive: false,
            title: Text('Add photo'),
            content: Center(
                child:
                    Text('First step', style: TextStyle(color: Colors.black)))),
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
}
