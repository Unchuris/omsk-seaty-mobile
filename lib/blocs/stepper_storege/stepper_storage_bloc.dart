import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/http.dart';
import 'package:http_parser/http_parser.dart';
part 'stepper_storage_event.dart';
part 'stepper_storage_state.dart';

class StepperStorageBloc
    extends Bloc<StepperStorageEvent, StepperStorageState> {
  StepperStorageBloc() : super(StepperStorageInitial());
  String imagePath;
  String commentText;
  double lat;
  double lon;
  String name;
  String address;
  int rating;
  Map<Object, bool> features;
  @override
  Stream<StepperStorageState> mapEventToState(
    StepperStorageEvent event,
  ) async* {
    if (event is AddImagePath) {
      imagePath = event.imagePath;
      name = event.name;
      address = event.address;
      lat = event.lat;
      lon = event.lon;
      yield AddImagePathState();
    } else if (event is AddFeature) {
      features = event.features;
      yield AddFeatureState();
    } else if (event is AddComment) {
      rating = event.rating;
      commentText = event.text;
      yield AddCommentState();
      add(RequestEvent());
    } else if (event is RequestEvent) {
      try {
        var file_name = imagePath.split('/').last;
        var feature;
        Map<String, String> json_feature;
        if (features != null) {
          feature = _getFeatures(features);
          json_feature = flattenTranslations(feature);
        }

        var formData = FormData();

        String Srating = rating.toString();
        formData.fields
          ..add(MapEntry("name", name))
          ..add(MapEntry("address", address))
          ..add(MapEntry("lat", lat.toString()))
          ..add(MapEntry("lon", lon.toString()))
          ..add(MapEntry("text", commentText))
          ..add(MapEntry("rating", Srating));
        if (features != null) {
          formData.fields.add(
              MapEntry(json_feature.keys.first, json_feature.values.first));
        }

        formData.files.add(MapEntry(
            "file",
            await MultipartFile.fromFile(imagePath,
                filename: file_name, contentType: MediaType('image', 'png'))));

        var responce = await dio
            .post("https://355032-cu98624.tmweb.ru/api/bench/", data: formData);
        yield SucessState();
      } on DioError catch (e) {
        if (e.response.statusCode == 403) {
          yield Error403State();
        } else if (e.response.statusCode == 413) {
          yield Error413State();
        } else {
          yield ErrorState();
        }
      }
    }
  }

  _getFeatures(Map<BenchType, bool> features) {
    var feature = [];
    features.forEach((key, value) {
      if (value == true) {
        switch (key) {
          case BenchType.URN_NEARBY:
            feature.add("Урна рядом");

            break;
          case BenchType.TABLE_NEARBY:
            feature.add("Стол Рядом");
            break;
          case BenchType.COVERED_BENCH:
            feature.add("Крытая лавочка");
            break;
          case BenchType.FOR_A_LARGE_COMPANY:
            feature.add("Для большой компании");
            break;
          case BenchType.SCENIC_VIEW:
            feature.add("Живописный вид");
            break;
          default:
        }
      }
    });
    var f = {"  ": feature};
    return f;
  }

  Map flattenTranslations(Map<String, dynamic> json, [String prefix = '']) {
    final Map<String, String> translations = {};
    json.forEach((String key, dynamic value) {
      if (value is Map) {
        translations.addAll(flattenTranslations(value, '$prefix$key.'));
      } else {
        translations['$prefix$key'] = value.toString();
      }
    });
    return translations;
  }
}
