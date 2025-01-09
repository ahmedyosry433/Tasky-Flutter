import 'package:tasky/Features/Login/Data/Apis/login_apis_service.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';

class LoginRepo {
  final LoginApisService _loginApisService;
  LoginRepo(this._loginApisService);

  Future loginRepo({required LoginModel loginModel}) async {
    return await _loginApisService.login( loginModel);
  }
}
