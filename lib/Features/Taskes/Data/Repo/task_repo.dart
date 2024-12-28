import 'package:tasky/Core/Networking/api_service.dart';

class TaskRepo {
  final ApiService _api_service;
  TaskRepo(this._api_service);

  Future logoutRepo({required String token}) {
    return _api_service.logout(token: token);
  }
}
