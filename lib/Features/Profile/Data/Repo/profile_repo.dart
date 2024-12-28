import 'package:tasky/Core/Networking/api_service.dart';

class ProfileRepo {
  ApiService _apiService;
  ProfileRepo(this._apiService);

  Future getProfile({required String token}) async {
    return await _apiService.profile(token: token);
  }
}
