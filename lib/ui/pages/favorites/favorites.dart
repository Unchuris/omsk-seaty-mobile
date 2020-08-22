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
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state is FavoritesPageLoading) {
            print('loading');
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state is FavoritesPageInitialed) {
            print('load');
            return _buildBenchCard(state.benchCard);
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
}
