import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/bench.dart';
import 'package:omsk_seaty_mobile/ui/widgets/like.dart';
import 'package:omsk_seaty_mobile/ui/widgets/route.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';

class BenchFavoriteCard extends StatefulWidget {
  final UIBencCard bench;

  const BenchFavoriteCard({this.bench}) : super();

  @override
  _BenchFavoriteCardState createState() => _BenchFavoriteCardState();
}

class _BenchFavoriteCardState extends State<BenchFavoriteCard> {
  static const _CIRCLE_RADIUS = 12.0;

  @override
  Widget build(BuildContext context) {
    var bench = widget.bench;
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
                  //TODO есть бага, сначала индикатор загрузки в левом верхнем углы, а потом по центру становится
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
                        children: <Widget>[
                          _getBottomPanel(bench),
                          _getRate(bench)
                        ])),
              ],
            )),
      ),
    );
  }

  Widget _getBottomPanel(UIBencCard bench) {
    return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
              RouteButton(lat: bench.lat, lon: bench.lon),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: LikeButton(bench: bench),
              )
            ],
          )
        ]));
  }

  Widget _getRate(UIBencCard bench) {
    return Positioned(
      top: 8,
      right: 16,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 16.0),
            child: SvgPicture.asset(
              "assets/rate.svg",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Text(
              bench.rate.toStringAsFixed(1),
              style: TextStyle(
                  fontFamily: "Roboto", fontSize: 14.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
