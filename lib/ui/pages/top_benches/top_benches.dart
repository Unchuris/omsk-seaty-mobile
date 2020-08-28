import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/top_benches/top_benches_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/model/ui_bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/bench_card_favorites.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';

class TopBechesPage extends StatefulWidget {
  TopBechesPage({Key key}) : super(key: key);
  static String routeName = "/top-benches";

  @override
  _TopBechesPageState createState() => _TopBechesPageState();
}

class _TopBechesPageState extends State<TopBechesPage> {
  TopBenchesBloc _bloc = TopBenchesBloc();

  @override
  void initState() {
    _bloc.add(GetTopBenchesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('top_benches')),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<TopBenchesBloc, TopBenchesState>(
            builder: (context, state) {
          if (state is TopBenchesInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TopBenchesPageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TopBenchesPageInitialed) {
            return _buildBenchCard(state.benchCard);
          } else if (state is TopBenchesPageError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TODO
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
                  onPressed: () => {_bloc.add(GetTopBenchesEvent())},
                  elevation: 8.0,
                  fillColor: Theme.of(context).buttonColor,
                  child: Icon(Icons.refresh),
                  padding: EdgeInsets.only(
                      left: 19.0, right: 19.0, top: 15, bottom: 15),
                  shape: CircleBorder(),
                )
              ],
            ));
          } else {
            return Container();
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
