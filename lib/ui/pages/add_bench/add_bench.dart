import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/steps/step_add_information.dart';
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
        _buildAddInformationStep(),
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

  _buildAddInformationStep() {
    return AddBenchStep(
        title: Text('Add information'), content: AddInformationStep());
  }

  /*_buildAddInformationStep() {
    return AddBenchStep(
        title: Text('Add information'),
        content: Container(
            width: double.infinity,
            child: Column(
              children: [
                Text('About bench',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black)),
                Row(
                  children: [
                    _buildAddInformationButton(),
                    _buildInformationButtons()
                  ],
                )
              ],
            )));
  }

  _buildAddInformationButton() {
    Map<BenchType, bool> benches = {
      BenchType.TABLE_NEARBY: false,
      BenchType.COVERED_BENCH: false,
      BenchType.SCENIC_VIEW: false,
      BenchType.FOR_A_LARGE_COMPANY: false
    };

    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 30,
      width: 30,
      child: RawMaterialButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ListProvider(
                  benches,
                  BlocProvider<InformationAboutBloc>(
                      create: (context) => _informationAboutBloc,
                      child: DialogWithChild(
                          title: AppLocalizations.of(context)
                              .translate('dialog_title_choose'),
                          buttonText: AppLocalizations.of(context)
                              .translate('dialog_button_add'),
                          child: CheckBoxList(),
                          buttonType: DialogButtonType.LIST))));
        },
        fillColor: Colors.orange,
        child: Icon(
          Icons.add,
          size: 24.0,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  _buildInformationButtons() {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(left: 16),
        child: BlocProvider(
            create: (context) => _informationAboutBloc,
            child: BlocBuilder<InformationAboutBloc, InformationAboutState>(
              builder: (context, state) {
                if (state is InformationAboutDone) {
                  return Text('Test yes',
                      style: TextStyle(color: Colors.black));
                }
                return Text('Test no', style: TextStyle(color: Colors.black));
              },
            )));
  }*/

  _buildAddImageStep(BuildContext context) {
    return AddBenchStep(
        title: Text('Add photo'),
        content: Container(
            child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _buildBackgroundAddedPhoto(context),
                Column(
                  children: [
                    _buildAddImageButton(context),
                    SizedBox(height: 8),
                    Text('Add photo')
                  ],
                )
              ],
            )
          ],
        )));
  }

  Widget _buildBackgroundAddedPhoto(BuildContext context) {
    return BlocBuilder<AddImageBloc, AddImageState>(builder: (context, state) {
      if (state is AddImageSuccess) {
        return Container(
          height: 160,
          child: state.image,
        );
      }
      return Container(
        height: 160,
        color: Color(0x66000000),
      );
    });
  }

  Widget _buildAddImageButton(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      child: RawMaterialButton(
        onPressed: () {
          BlocProvider.of<AddImageBloc>(context)
              .add(AddImageStarted(Image.network(
            'https://mk0kaypark81bx11qkx7.kinstacdn.com/wp-content/uploads/2019/11/JPCB42.png',
          )));
        },
        fillColor: Colors.orange,
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
        shape: CircleBorder(),
      ),
    );
  }
}
