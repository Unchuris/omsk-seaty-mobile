import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/http.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import 'package:url_launcher/url_launcher.dart';

class BenchCard extends StatefulWidget {
  final BenchLight bench;
  const BenchCard({this.bench}) : super();

  @override
  _BenchCardState createState() => _BenchCardState();
}

class _BenchCardState extends State<BenchCard> {
  @override
  Widget build(BuildContext context) {
    var bench = UIBencCard(widget.bench.name, widget.bench.score,
        widget.bench.imageUrl, widget.bench.like);
    return _buildBenchCard(bench);
  }

  Widget _buildBenchCard(UIBencCard bench) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BenchPage(
                      benchId: widget.bench.id,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        child: Container(
            width: MediaQuery.of(context).size.width * .90,
            height: MediaQuery.of(context).size.height * .28,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(bench.imageUrl),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Stack(alignment: AlignmentDirectional.bottomEnd, children: <
                Widget>[
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
                            bench.name,
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
                child: RawMaterialButton(
                  onPressed: _launchURL,
                  fillColor: Colors.white,
                  child: SvgPicture.asset("assets/road.svg"),
                  padding: EdgeInsets.all(5),
                  shape: CircleBorder(),
                ),
              ),
              Positioned(
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
                            fontFamily: "Roboto",
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .165,
                right: 0,
                child: RawMaterialButton(
                  onPressed: () async {
                    if (bench.like) {
                      setState(() {
                        bench.like = false;
                      });
                      var user =
                          BlocProvider.of<AuthenticationBloc>(context).getUser;
                      var respone =
                          await dio.patch('/benches/${widget.bench.id}/like/');
                      BlocProvider.of<MapBloc>(context).add(OnLikeClickedEvent(
                          markerId: widget.bench.id, liked: bench.like));
                    } else {
                      setState(() {
                        bench.like = true;
                      });
                      var user =
                          BlocProvider.of<AuthenticationBloc>(context).getUser;
                      var respone =
                          await dio.put('/benches/${widget.bench.id}/like/');
                      BlocProvider.of<MapBloc>(context).add(OnLikeClickedEvent(
                          markerId: widget.bench.id, liked: bench.like));
                    }
                  },
                  fillColor: Colors.white,
                  child: bench.like
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

  _launchURL() async {
    var url =
        'https://www.google.ru/maps/dir/?api=1&destination=${widget.bench.latitude},${widget.bench.longitude}&travelmode=walking';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
