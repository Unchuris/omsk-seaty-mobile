import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_bench/add_photo_map.dart';

class AddPhotoScreen extends StatelessWidget {
  final Function onNextButton;

  const AddPhotoScreen({Key key, Function onNextButton})
      : onNextButton = onNextButton,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _buildBackgroundAddedPhoto(context),
              Column(
                children: [
                  _buildAddImageButton(context),
                  SizedBox(height: 8),
                  Text(AppLocalizations.of(context)
                      .translate("string_add_photo"))
                ],
              )
            ],
          ),
          BlocBuilder<AddImageBloc, AddImageState>(builder: (context, state) {
            if (state is AddImageSuccess) {
              return _buildAddressRow(context, state);
            } else if (state is AddImageLocationLoading) {
              return Container(
                  child: Center(child: CircularProgressIndicator()),
                  height: 80);
            } else {
              return Container(
                  child: Center(
                      child: Text(AppLocalizations.of(context).translate("string_add_new_photo"),
                          style: Theme.of(context).textTheme.bodyText1)),
                  height: 80);
            }
          }),
          Divider()
        ]),
        _buildNextButton(context)
      ],
    ));
  }

  Container _buildNextButton(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(24),
        child: MaterialButton(
          onPressed: onNextButton,
          child: Text(AppLocalizations.of(context).translate("string_next")),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
        ));
  }

  Container _buildAddressRow(BuildContext context, AddImageSuccess state) {
    final noLocationString =
        AppLocalizations.of(context).translate("string_no_location");
    return Container(
        padding: EdgeInsets.only(top: 16, bottom: 8, left: 12, right: 12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: <Widget>[
              Icon(Icons.location_on,
                  color: Theme.of(context).textTheme.bodyText1.color),
              Container(
                  width: 160,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(state.address ?? noLocationString,
                      style: Theme.of(context).textTheme.bodyText1))
            ],
          ),
          TextButton(
              child: Text(
                  AppLocalizations.of(context).translate("string_on_map"),
                  style: TextStyle(color: Theme.of(context).accentColor)),
              onPressed: () =>
                  _showMapForBenchLocation(context, state.geoPoint)),
        ]));
  }

  Widget _buildBackgroundAddedPhoto(BuildContext context) {
    return BlocBuilder<AddImageBloc, AddImageState>(builder: (context, state) {
      if (state is AddImageSuccess) {
        return _getPhoto(state.imagePath);
      } else if (state is AddImageLocationLoading) {
        return _getPhoto(state.imagePath);
      }
      return Container(
        height: 160,
        color: Color(0x66000000),
      );
    });
  }

  Container _getPhoto(String imagePath) {
    return Container(
        height: 160,
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.6),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.dstATop),
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover)));
  }

  Widget _buildAddImageButton(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      child: RawMaterialButton(
        onPressed: () {
          _onTakePhotoPressed(context);
        },
        fillColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
          size: 32.0,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  Future<void> _onTakePhotoPressed(BuildContext context) async {
    _showSourceSelectionDialog(context);
  }

  Future<void> _showSourceSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .translate("string_select_from_where")),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(AppLocalizations.of(context)
                          .translate("string_gallery")),
                      onTap: () async {
                        await _setImageFromSource(
                            dialogContext, ImageSource.gallery);
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(AppLocalizations.of(context)
                          .translate("string_camera")),
                      onTap: () async {
                        await _setImageFromSource(
                            dialogContext, ImageSource.camera);
                        Navigator.of(dialogContext).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> _setImageFromSource(
      BuildContext context, ImageSource imageSource) async {
    final image = await ImagePicker().getImage(source: imageSource);
    BlocProvider.of<AddImageBloc>(context).add(AddImageStarted(image.path));
  }

  void _showMapForBenchLocation(BuildContext context, GeoPoint location) async {
    final mapLocation = location ?? await getCurrentLocation();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AddPhotoMapScreen(startPoint: mapLocation)))
        .then((value) {
      if (value != null) {
        BlocProvider.of<AddImageBloc>(context).add(AddImageLocation(value));
      }
    });
  }

  Future<GeoPoint> getCurrentLocation() async {
    final location = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(latitude: location.latitude, longitude: location.longitude);
  }
}
