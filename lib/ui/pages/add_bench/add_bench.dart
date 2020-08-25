import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';

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
