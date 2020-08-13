import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/ui/widgets/bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key key}) : super(key: key);
  static String roateName = "/favorites";
  @override
  Widget build(BuildContext context) {
    final List<MapMarker> mapMarkers =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('string_favorites')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return BenchCard(marker: mapMarkers[index]);
        },
        itemCount: mapMarkers.length,
      ),
    );
  }
}