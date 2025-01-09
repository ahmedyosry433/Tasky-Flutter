import 'package:tasky/Features/Register/Data/Apis/register_apis_service.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';

class RegisterRepo {
  final RegisterApisService _registerApisService;
  RegisterRepo(this._registerApisService);

  Future registerRepo({required UserModel registerModel}) async {
    return await _registerApisService.register(registerModel);
  }
}
