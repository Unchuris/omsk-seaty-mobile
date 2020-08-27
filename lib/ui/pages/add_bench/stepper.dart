import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BenchStep {
  final String title;
  final Widget body;

  const BenchStep({Key key, this.title, this.body});
}

class BenchMaterialStepper extends StatelessWidget {
  final List<BenchStep> steps;
  final int currentStep;

  const BenchMaterialStepper(
      {Key key, @required this.steps, @required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rowWidgets = <Widget>[];
    final stepsAmount = steps.length;
    for (int i = 0; i <= currentStep; i++) {
      rowWidgets.add(_stepWidget(context, i, steps[i].title, true));
      if (i != stepsAmount - 1) {
        rowWidgets.add(_stepLine(context, i != currentStep));
      }
    }
    for (int i = currentStep + 1; i < stepsAmount; i++) {
      rowWidgets.add(_stepWidget(context, i, steps[i].title, false));
      if (i != stepsAmount - 1) {
        rowWidgets.add(_stepLine(context, false));
      }
    }

    return Column(children: [
      Container(
          padding: EdgeInsets.only(top: 16, left: 32, right: 32),
          child: Container(
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: rowWidgets)))),
      Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps
                .map((step) => Text(step.title,
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).accentColor)))
                .toList()),
      ),
      Expanded(child: steps[currentStep].body)
    ]);
  }

  Widget _stepWidget(
      BuildContext context, int index, String title, bool active) {
    return Opacity(
        opacity: active ? 1 : 0.5,
        child: Container(
            padding: EdgeInsets.all(8),
            child: Column(children: [
              Row(children: [
                CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    maxRadius: 12,
                    child: Text((index + 1).toString(),
                        style: Theme.of(context).textTheme.bodyText2)),
              ]),
            ])));
  }

  Widget _stepLine(BuildContext context, bool active) {
    return Expanded(
      child: Opacity(
          opacity: active ? 1 : 0.5,
          child: Container(height: 2, color: Theme.of(context).accentColor)),
    );
  }
}
