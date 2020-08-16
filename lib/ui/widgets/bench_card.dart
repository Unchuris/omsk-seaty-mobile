import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';

class BenchCard extends StatefulWidget {
  final MapMarker marker;
  const BenchCard({this.marker}) : super();

  @override
  _BenchCardState createState() => _BenchCardState();
}

class _BenchCardState extends State<BenchCard> {
  @override
  Widget build(BuildContext context) {
    var bench = UIBencCard(widget.marker.locationName, 4.5,
        widget.marker.imageUrl, widget.marker.isFavorites);
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: GestureDetector(
        onDoubleTap: () {
          Navigator.pushNamed(context, BenchPage.routeName,
              arguments: widget.marker);
        },
        child: Container(
            width: MediaQuery.of(context).size.width * .90,
            height: MediaQuery.of(context).size.height * .28,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(bench.imageUrl),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          height: MediaQuery.of(context).size.height * .08,
                          padding: EdgeInsets.only(left: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0)),
                              color: Color.fromRGBO(0, 0, 0, 0.6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                bench.locationName,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18.5,
                                    fontFamily: "Roboto"),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * .165,
                    right: 50,
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.white,
                      child: Image.asset(
                        "assets/road.png",
                        width: 30,
                        fit: BoxFit.contain,
                      ),
                      padding: EdgeInsets.all(5),
                      shape: CircleBorder(),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * .165,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {
                        if (bench.isFavorites) {
                          setState(() {
                            bench.isFavorites = false;
                          });
                          widget.marker.isFavorites = false;

                          print("убрал лайк ${widget.marker.locationName}");
                          BlocProvider.of<MapBloc>(context)
                              .add(LikeButtonPassEvent(marker: widget.marker));
                        } else {
                          setState(() {
                            bench.isFavorites = true;
                          });
                          widget.marker.isFavorites = true;

                          print("поставил лайк ${widget.marker.locationName}");
                          BlocProvider.of<MapBloc>(context)
                              .add(LikeButtonPassEvent(marker: widget.marker));
                        }
                      },
                      color: Colors.white,
                      child: bench.isFavorites
                          ? SvgPicture.asset("assets/like.svg")
                          : SvgPicture.asset("assets/unlike.svg"),
                      padding: EdgeInsets.all(5),
                      shape: CircleBorder(),
                    ),
                  ),
                ])),
      ),
    );
  }
}
