import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';

import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';

import 'package:omsk_seaty_mobile/http.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';

class BenchFavoriteCard extends StatefulWidget {
  final UIBencCard bench;
  const BenchFavoriteCard({this.bench}) : super();

  @override
  _BenchFavoriteCardState createState() => _BenchFavoriteCardState();
}

class _BenchFavoriteCardState extends State<BenchFavoriteCard> {
  @override
  Widget build(BuildContext context) {
    var bench = widget.bench;
    return Padding(
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
                child: ButtonTheme(
                  minWidth: 63.0,
                  height: 56.0,
                  child: RaisedButton(
                      child: Text("В путь",
                          style: Theme.of(context).textTheme.button),
                      onPressed: () {}),
                )),
            Positioned(
              top: MediaQuery.of(context).size.height * .165,
              right: 0,
              child: MaterialButton(
                onPressed: () async {
                  if (bench.like) {
                    setState(() {
                      bench.like = false;
                    });
                    var user =
                        BlocProvider.of<AuthenticationBloc>(context).getUser;
                    var respone = await dio.patch('/favorites/${user.uid}',
                        data: {'uid': user.uid, 'bench_id': widget.bench.id});
                    BlocProvider.of<MapBloc>(context).add(OnLikeClickedEvent(
                        markerId: widget.bench.id, liked: bench.like));
                  } else {
                    setState(() {
                      bench.like = true;
                    });
                    var user =
                        BlocProvider.of<AuthenticationBloc>(context).getUser;
                    var respone = await dio.put('/favorites/${user.uid}',
                        data: {'uid': user.uid, 'bench_id': widget.bench.id});
                    BlocProvider.of<MapBloc>(context).add(OnLikeClickedEvent(
                        markerId: widget.bench.id, liked: bench.like));
                  }
                },
                color: Colors.white,
                child: bench.like
                    ? SvgPicture.asset("assets/like.svg")
                    : SvgPicture.asset("assets/unlike.svg"),
                padding: EdgeInsets.all(5),
                shape: CircleBorder(),
              ),
            ),
          ])),
    );
    ;
  }
}
