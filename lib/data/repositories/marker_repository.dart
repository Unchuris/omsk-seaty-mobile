import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/http.dart';

import '../models/bench_light.dart';

class MarkerRepository {
  Set<FilterType> filters = Set.from([
    FilterType(benchType: BenchType.HIGH_COMFORT, enable: false),
    FilterType(benchType: BenchType.URN_NEARBY, enable: false),
    FilterType(benchType: BenchType.TABLE_NEARBY, enable: false),
    FilterType(benchType: BenchType.COVERED_BENCH, enable: false),
    FilterType(benchType: BenchType.FOR_A_LARGE_COMPANY, enable: false),
    FilterType(benchType: BenchType.SCENIC_VIEW, enable: false),
    FilterType(benchType: BenchType.BUS_STOP, enable: false)
  ]);
  List<BenchLight> benches = List();

  List<BenchLight> filteredBenches = List();

  //TODO remove mock data
  final List<String> imgList = [
    'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg',
    'https://varlamov.me/2018/omsk/48.jpg',
    'https://superomsk.ru/images/uploading/b27000d014f07c29554b7b461ee04b4d.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRurKuj6R4YRCZ6rLbJzKMRaVrLOoPgo6aKqw&usqp=CAU',
  ];

  Future<List<BenchLight>> getMarkers() async {
    if (benches.isNotEmpty) {
      filteredBenches = _getFilteredBenches();
      return filteredBenches;
    }
    //TODO add https://pub.dev/packages/dio

    final response = await dio.get(
      "/benches",
    );

    if (response.statusCode == 200) {
      benches =
          ((response.data) as List).map((i) => BenchLight.fromJson(i)).toList();
      filteredBenches = _getFilteredBenches();
      return filteredBenches;
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }

  List<BenchLight> _getFilteredBenches() {
    Set<BenchType> currentFilter =
        filters.where((it) => it.enable).map((it) => it.benchType).toSet();
    return benches
        .where((it) => it.feature.containsAll(currentFilter))
        .toList();
  }

  Future<List<BenchLight>> getClusterBenches(List<String> markersId) async {
    return filteredBenches.where((it) => markersId.contains(it.id)).toList();
  }

  Future<List<BenchLight>> getBenchesByVisibleRegion(
      LatLngBounds latLngBounds) async {
    return filteredBenches
        .where((it) => latLngBounds.contains(LatLng(it.latitude, it.longitude)))
        .toList();
  }
}
