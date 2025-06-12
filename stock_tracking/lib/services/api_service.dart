import 'package:stock_tracking/models/user_model.dart';
import 'package:stock_tracking/services/db_service.dart';

class ApiService {
  static Future<bool> login(String username, String password) async {
    final user = await DBService.instance.getUser(username, password);
    if (user == null) return false;
    return true; 
  }
}
