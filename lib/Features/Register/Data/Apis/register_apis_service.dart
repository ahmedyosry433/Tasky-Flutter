import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';

class RegisterApisService extends BaseApiService {
  RegisterApisService(super.dio);
  Future<dynamic> register(UserModel userModel) async {
    return post( ApiConstants.registerUrl,
        data: userModel.toJson());
  }
}
