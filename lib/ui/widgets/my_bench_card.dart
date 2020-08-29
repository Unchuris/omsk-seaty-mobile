import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/model/my_bench_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBenchCard extends StatefulWidget {
  final UiMyBench bench;
  const MyBenchCard({this.bench}) : super();

  @override
  _MyBenchCardState createState() => _MyBenchCardState();
}

class _MyBenchCardState extends State<MyBenchCard> {
  @override
  Widget build(BuildContext context) {
    var bench = widget.bench;
    Widget benchCard;
    switch (bench.status) {
      case "PENDING":
        benchCard = _pendginCard(bench);
        break;
      case "IN_POOL":
        benchCard = _inPoolCard(bench);
        break;
      case "REJECTED":
        break;
      default:
    }
    return (bench.status == "IN_POOL")
        ? Padding(
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
              child: Container(
                  width: MediaQuery.of(context).size.width * .90,
                  height: MediaQuery.of(context).size.height * .28,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(bench.imageUrl),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: benchCard),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Container(
                width: MediaQuery.of(context).size.width * .90,
                height: MediaQuery.of(context).size.height * .28,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(bench.imageUrl),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: benchCard),
          );
  }

  Widget _pendginCard(UiMyBench bench) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      Row(
        children: <Widget>[
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * .96,
              height: MediaQuery.of(context).size.height * .96,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)),
                  color: Color.fromRGBO(0, 0, 0, 0.6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context).translate('pending_card'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
    ]);
  }

  Widget _inPoolCard(UiMyBench bench) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
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
                  Text(bench.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white)),
                ],
              ),
            ),
          )
        ],
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
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
      Positioned(
          bottom: 0,
          right: 16,
          child: ButtonTheme(
            minWidth: 24.0,
            height: 34.0,
            child: RawMaterialButton(
                elevation: 8.0,
                fillColor: Theme.of(context).buttonColor,
                child: Text(AppLocalizations.of(context).translate('route'),
                    style: Theme.of(context).textTheme.button),
                onPressed: _launchURL),
          )),
    ]);
  }

  _launchURL() async {
    var url =
        'https://www.google.ru/maps/dir/?api=1&destination=${widget.bench.lat},${widget.bench.lon}&travelmode=walking';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
