import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/my_benches/my_benches_bloc.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/model/my_bench_ui.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';
import 'package:omsk_seaty_mobile/ui/widgets/my_bench_card.dart';
import 'package:omsk_seaty_mobile/ui/widgets/snackbar.dart';

class MyBenchPage extends StatefulWidget {
  MyBenchPage({Key key}) : super(key: key);
  static String routeName = "/mybenches";

  @override
  _MyBenchPageState createState() => _MyBenchPageState();
}

class _MyBenchPageState extends State<MyBenchPage> {
  MyBenchesBloc _bloc = MyBenchesBloc();
  @override
  void initState() {
    _bloc.add(GetMyBenchesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('my_benches')),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<MyBenchesBloc, MyBenchesState>(
            builder: (context, state) {
          if (state is MyBenchesInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MyBenchesPageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MyBenchesPageInitialed) {
            return _buildBenchCard(state.benchCard);
          } else if (state is MyBenchesPageError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate("network_connection_error"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate("cheak_network_try_again"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 60,
                ),
                RawMaterialButton(
                  onPressed: () => {_bloc.add(GetMyBenchesEvent())},
                  elevation: 8.0,
                  fillColor: Theme.of(context).buttonColor,
                  child: Icon(Icons.refresh),
                  padding: EdgeInsets.only(
                      left: 19.0, right: 19.0, top: 15, bottom: 15),
                  shape: CircleBorder(),
                )
              ],
            ));
          } else if (state is MyBenchesPage403Error) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    AppLocalizations.of(context).translate("403_error"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () => {Navigator.pushNamed(context, "/login")},
                  elevation: 8.0,
                  fillColor: Theme.of(context).buttonColor,
                  child: Text(
                    AppLocalizations.of(context).translate("login_in"),
                    style: Theme.of(context).textTheme.button,
                  ),
                  padding: EdgeInsets.only(
                      left: 19.0, right: 19.0, top: 15, bottom: 15),
                )
              ],
            ));
          } else {
            return Container();
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var user = BlocProvider.of<AuthenticationBloc>(context).getUser;
          if (user == null || user.uid ==""){
            Scaffold.of(context).showSnackBar(getSnackBarError(AppLocalizations.of(context).translate("403_error"), context));
          }
          else {
            Navigator.pushNamed(context, '/add_bench');
          }
        },
        elevation: 8.0,
        backgroundColor: Theme.of(context).buttonColor,
        child: SvgPicture.asset("assets/ic_add_bench.svg"),
        shape: CircleBorder(),
      ),
    );
  }

  _buildBenchCard(List<UiMyBench> benches) {
    if (benches.length == 0) {
      return Container(
          child: Center(
              child: Text(
        AppLocalizations.of(context).translate("favorites_empty"),
        style: Theme.of(context).textTheme.bodyText1,
      )));
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return MyBenchCard(bench: benches[index]);
        },
        itemCount: benches.length,
      );
    }
  }
}
