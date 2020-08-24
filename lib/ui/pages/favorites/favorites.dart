import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/favorites/favorites_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/bench_card_favorites.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';

class FavoritesPage extends StatefulWidget {
  final String uid;
  const FavoritesPage({Key key, this.uid}) : super(key: key);
  static String routeName = "/favorites";

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<UIBencCard> _benches;
  FavoritesBloc _bloc = FavoritesBloc();
  @override
  void initState() {
    _bloc.add(GetFavoritesEvent(uid: widget.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('string_favorites')),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
          if (state is FavoritesInitial) {
            print('initial');
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoritesPageLoading) {
            print('loading');
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoritesPageInitialed) {
            print('load');
            return _buildBenchCard(state.benchCard);
          } else if (state is FavoritesPageError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ошибка соединения",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "Проверьте соединение и попробуйте еще.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 60,
                ),
                RawMaterialButton(
                  onPressed: () =>
                      {_bloc.add(GetFavoritesEvent(uid: widget.uid))},
                  elevation: 8.0,
                  fillColor: Theme.of(context).buttonColor,
                  child: Icon(Icons.refresh),
                  padding: EdgeInsets.only(
                      left: 19.0, right: 19.0, top: 15, bottom: 15),
                  shape: CircleBorder(),
                )
              ],
            ));
          }
        }),
      ),
    );
  }

  _buildBenchCard(List<UIBencCard> benches) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return BenchFavoriteCard(bench: benches[index]);
      },
      itemCount: benches.length,
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
