import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';

class RouteButton extends StatefulWidget {
  final double lat;
  final double lon;

  const RouteButton({Key key, @required this.lat, @required this.lon}) : super(key: key);

  @override
  _RouteButtonState createState() => _RouteButtonState();
}

class _RouteButtonState extends State<RouteButton> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      onPressed: () => _launchURL(widget.lat, widget.lon),
      child: Text(
        AppLocalizations.of(context).translate("route").toUpperCase(),
        style: Theme.of(context).textTheme.caption,
      ),
      fillColor: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)),
    );
  }

  _launchURL(double lat, double lon) async {
    var url =
        'https://www.google.ru/maps/dir/?api=1&destination=$lat,$lon&travelmode=walking';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
