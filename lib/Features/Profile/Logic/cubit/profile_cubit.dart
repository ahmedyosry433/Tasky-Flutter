import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tasky/Core/helper/shared_preferences_helper.dart';
import 'package:tasky/Features/Profile/Data/Repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileRepo _profileRepo;
  ProfileCubit(this._profileRepo) : super(ProfileInitial());

  String? displayName;
  String? phone;
  String? level;
  int? yearsOfExperience;
  String? address;

  void getProfile() async {
    emit(ProfileLoading());
    try {
      String token = await SharedPreferencesHelper.getValueForKey("token");
      final res = await _profileRepo.getProfile(token: token);
      displayName = res["displayName"];
      phone = res["username"];
      level = res["level"];
      yearsOfExperience = res["experienceYears"];
      address = res["address"];

      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
