import 'package:tasky/Core/Networking/api_service.dart';

class ProfileRepo {
  ApiService _apiService;
  ProfileRepo(this._apiService);

  Future getProfile() async {
    return _apiService.profile();
  }
}
