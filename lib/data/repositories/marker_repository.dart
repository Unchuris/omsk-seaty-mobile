import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/data/models/benches.dart';


class MarkerRepository {

  Set<FilterType> filters = Set.from(
    [
      FilterType(benchType: BenchType.HIGH_COMFORT, enable: false),
      FilterType(benchType: BenchType.URN_NEARBY, enable: false),
      FilterType(benchType: BenchType.TABLE_NEARBY, enable: false),
      FilterType(benchType: BenchType.COVERED_BENCH, enable: false),
      FilterType(benchType: BenchType.FOR_A_LARGE_COMPANY, enable: false),
      FilterType(benchType: BenchType.SCENIC_VIEW, enable: false),
      FilterType(benchType: BenchType.BUS_STOP, enable: false)
    ]
  );
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
    var url = "https://omsk-seaty-backend.herokuapp.com/api/benches/";
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var b = Bench.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      var rng = new Random();
      benches = b.benches.map((it) => _getBenchLight(it, rng)).toList();
      filteredBenches = _getFilteredBenches();
      return filteredBenches;
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }

  BenchLight _getBenchLight(Benches it, Random rng) {
    return BenchLight( //TODO remove mapper
        id: it.pk.toString(),
        name: it.title,
        address: it.place,
        latitude: it.latitude,
        longitude: it.longitude,
        imageUrl: imgList[rng.nextInt(imgList.length)],
        like: (rng.nextInt(1) == 1) ? true : false,
        score: 228,
        feature: _getMockFilter(rng.nextInt(3))
    );
  }

  List<BenchLight> _getFilteredBenches() {
    Set<BenchType> currentFilter = filters.where((it) => it.enable).map((it) => it.benchType).toSet();
    return benches.where((it) => it.feature.containsAll(currentFilter)).toList();
  }

  //TODO remove mock data
  Set<BenchType> _getMockFilter(int i) {
    switch (i) {
      case 0:
        return Set.from([
          BenchType.BUS_STOP,
          BenchType.COVERED_BENCH,
          BenchType.TABLE_NEARBY,
        ]);
      case 1:
        return Set.from([
          BenchType.BUS_STOP,
          BenchType.COVERED_BENCH,
        ]);
      case 2:
        return Set.from([
          BenchType.BUS_STOP,
          BenchType.URN_NEARBY,
        ]);
      default:
        return Set.from([BenchType.BUS_STOP]);
    }
  }

  Future<List<BenchLight>> getClusterBenches(List<String> markersId) async {
    return filteredBenches.where((it) => markersId.contains(it.id)).toList();
  }

  Future<List<BenchLight>> getBenchesByVisibleRegion(LatLngBounds latLngBounds) async {
    return filteredBenches.where((it) => latLngBounds.contains(LatLng(it.latitude, it.longitude))).toList();
  }
}
