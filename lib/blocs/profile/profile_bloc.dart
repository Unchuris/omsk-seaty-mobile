import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:omsk_seaty_mobile/blocs/profile/profile_event.dart';
import 'package:omsk_seaty_mobile/blocs/profile/profile_state.dart';
import 'package:omsk_seaty_mobile/data/models/user_info.dart';

import '../../http.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetProfileEvent) {
      try {
        yield ProfileLoading();
        final response = await dio.get("/profile");
//        UserInfo userInfo = UserInfo(
//            "",
//            "Vlad Unchuris",
//            "vlad@effective.band",
//            "https://lh3.googleusercontent.com/a-/AOh14Giq-TYQDn9OH4yxR2BU06p0yfb0ie0v2pjiCvVY=s96-c",
//            1488,
//            true,
//            20,
//            41,
//            "Царь лавок 20 уровня"
//        );
        UserInfo userInfo = UserInfo.fromJson(response.data);
        yield ProfileSuccess(userInfo: userInfo);
      } on DioError catch (_) {
        yield ProfileError();
      }
    }
  }
}
