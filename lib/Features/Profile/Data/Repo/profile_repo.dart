import 'package:tasky/Features/Profile/Data/Apis/profile_apis_service.dart';

class ProfileRepo {
  ProfileApisService _profileApisService;
  ProfileRepo(this._profileApisService);

  Future getProfile() async {
    return _profileApisService.getProfile();
  }
}
