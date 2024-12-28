import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';

class LoginRepo {
  final ApiService _apiService;
  LoginRepo(this._apiService);

  Future loginRepo({required LoginModel loginModel}) async {
    return await _apiService.login(loginModel: loginModel);
  }
}
