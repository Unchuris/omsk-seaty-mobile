import 'package:flutter/material.dart';

import 'package:omsk_seaty_mobile/ui/widgets/app_drawer.dart';

class MapPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 30,
            left: 5,
            child: SizedBox(
              child: IconButton(
                splashColor: Colors.grey,
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
