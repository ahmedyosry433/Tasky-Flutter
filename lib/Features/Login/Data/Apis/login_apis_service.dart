import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';

class LoginApisService extends BaseApiService {
  LoginApisService(super.dio);

  Future<dynamic> login(LoginModel loginModel) async {
    return post( ApiConstants.loginrUrl,
        data: loginModel.toJson());
  }
}
