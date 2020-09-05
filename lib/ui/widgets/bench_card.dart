import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/route.dart';

import 'like.dart';

class BenchCard extends StatefulWidget {
  final BenchLight bench;

  const BenchCard({this.bench}) : super();

  @override
  _BenchCardState createState() => _BenchCardState();
}

class _BenchCardState extends State<BenchCard> {
  static const _CIRCLE_RADIUS = 12.0;

  @override
  Widget build(BuildContext context) {
    var bench = UIBencCard(widget.bench.id, widget.bench.name,
        widget.bench.score, widget.bench.imageUrl, widget.bench.like, widget.bench.latitude, widget.bench.longitude);
    return _buildBenchCard(bench);
  }

  Widget _buildBenchCard(UIBencCard bench) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(_CIRCLE_RADIUS)))),
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
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[_getBottomPanel(bench)])),
            ],
          )),
    );
  }

  Widget _getBottomPanel(UIBencCard bench) {
    return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_CIRCLE_RADIUS),
                bottomRight: Radius.circular(_CIRCLE_RADIUS)),
            color: Color.fromRGBO(0, 0, 0, 0.6)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(bench.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white))),
          ),
          Row(
            children: <Widget>[
              RouteIcon(
                  lat: bench.lat, lon: bench.lon),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: LikeButton(bench: bench),
              )
            ],
          )
        ]));
  }
}
