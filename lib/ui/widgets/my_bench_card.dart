import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/model/my_bench_ui.dart';

import 'bench_card_favorites.dart';

class MyBenchCard extends StatefulWidget {
  final UiMyBench bench;
  const MyBenchCard({this.bench}) : super();

  @override
  _MyBenchCardState createState() => _MyBenchCardState();
}

class _MyBenchCardState extends State<MyBenchCard> {
  static const _CIRCLE_RADIUS = 12.0;

  @override
  Widget build(BuildContext context) {
    var bench = widget.bench;
    Widget benchCard;
    switch (bench.status) {
      case "PENDING":
        benchCard = _pendingCard(bench, AppLocalizations.of(context).translate('pending_card'));
        break;
      case "IN_POOL":
        benchCard = _inPoolCard(bench);
        break;
      case "REJECTED":
        break;
      default:
    }
    return benchCard;
  }

  Widget _pendingCard(UiMyBench bench, String message) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BenchPage(
                    benchId: bench.id,
                  )));
        },
        child: AspectRatio(
            aspectRatio: 2 / 1,
            child: Stack(
              children: [
                CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: bench.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(
                              Radius.circular(_CIRCLE_RADIUS)))),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  //errorWidget: (context, url, error) => Icon(Icons.error), //TODO add error image
                ),
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xb2000000),
                              Color(0x33000000),
                              Color(0xb2000000)
                            ]),
                        borderRadius:
                        BorderRadius.all(Radius.circular(_CIRCLE_RADIUS)))),
                Align(
                    alignment: Alignment.center,
                    child: Text(message,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white)))
              ]
            )),
      ),
    );
  }

  Widget _inPoolCard(UiMyBench bench) {
    return BenchFavoriteCard(bench: UIBencCard(
        bench.id,
        bench.name,
        bench.rate,
        bench.imageUrl,
        null,
        bench.lat,
        bench.lon
    ));
  }
}
