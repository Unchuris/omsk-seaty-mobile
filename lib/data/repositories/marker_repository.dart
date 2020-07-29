import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:omsk_seaty_mobile/data/models/benches.dart';

/* Преобразую json в объекты лабочек затем в словарь с маркерами */
class MarkerRepository {
  Future<List<Benches>> getMarkers() async {
    var url = "https://omsk-seaty-backend.herokuapp.com/api/benches/json/";
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var b = Bench.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      return b.benches;
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }
}
