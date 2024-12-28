import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';

class RegisterRepo {
  final ApiService apiService;
  RegisterRepo({required this.apiService});

  Future registerRepo({required UserModel registerModel}) async {
    return await apiService.register(registerModel: registerModel);
  }
}
