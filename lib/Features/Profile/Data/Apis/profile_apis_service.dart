import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Networking/api_service.dart';

class ProfileApisService extends BaseApiService {
  ProfileApisService(super.dio);

  Future<dynamic> getProfile() async {
    return get( ApiConstants.profilerUrl);
  }
}
