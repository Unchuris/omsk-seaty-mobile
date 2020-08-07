import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';

class BenchCard extends StatelessWidget {
  final MapMarker marker;
  const BenchCard({this.marker}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .90,
        height: MediaQuery.of(context).size.height * .28,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                    "https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child:
            Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .90,
                height: MediaQuery.of(context).size.height * .10,
                padding: EdgeInsets.only(top: 20, left: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)),
                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      marker.locationName,
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 18.5,
                          fontFamily: "Roboto"),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .14,
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
        ]));
  }
}
