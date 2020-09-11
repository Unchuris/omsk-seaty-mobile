import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/snackbar.dart';

import '../../http.dart';

class LikeButton extends StatefulWidget {
  final UIBencCard bench;

  const LikeButton({
    Key key,
    @required this.bench,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    var bench = widget.bench;
    //TODO
    return ClipOval(
      child: Material(
        color: Colors.white, // button color
        child: InkWell(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: bench.like
                      ? SvgPicture.asset("assets/like.svg")
                      : SvgPicture.asset("assets/unlike.svg"))),
          onTap: () async {
            if (bench.like) {
              setState(() {
                bench.like = false;
              });
              try {
                var respone =
                    await dio.patch('/benches/${widget.bench.id}/like/');
                BlocProvider.of<MapBloc>(context).add(OnLikeClickedEvent(
                    markerId: widget.bench.id, liked: bench.like));
              } on DioError catch (e) {
                if (e.response == null) {
                  Scaffold.of(context).showSnackBar(getSnackBarError(
                      AppLocalizations.of(context)
                          .translate("network_connection_error"),
                      context));
                  setState(() {
                    bench.like = false;
                  });
                } else if (e.response.statusCode == 403) {
                  setState(() {
                    bench.like = true;
                  });
                  Scaffold.of(context).showSnackBar(getSnackBarError(
                      AppLocalizations.of(context).translate("403_error"),
                      context));
                }
              }
            } else {
              setState(() {
                bench.like = true;
              });
              try {
                var respone =
                    await dio.put('/benches/${widget.bench.id}/like/');
                BlocProvider.of<MapBloc>(context).add(OnLikeClickedEvent(
                    markerId: widget.bench.id, liked: bench.like));
              } on DioError catch (e) {
                if (e.response == null) {
                  Scaffold.of(context).showSnackBar(getSnackBarError(
                      AppLocalizations.of(context)
                          .translate("network_connection_error"),
                      context));
                  setState(() {
                    bench.like = false;
                  });
                } else if (e.response.statusCode == 403) {
                  setState(() {
                    bench.like = false;
                  });
                  Scaffold.of(context).showSnackBar(getSnackBarError(
                      AppLocalizations.of(context).translate("403_error"),
                      context));
                }
              }
            }
          },
        ),
      ),
    );
  }
}
