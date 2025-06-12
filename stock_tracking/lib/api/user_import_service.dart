// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stock_tracking/constants/app_constants.dart';
// import '../models/user_model.dart';
// import '../services/db_service.dart';

// class UserImportService {
//   static const String apiUrl =
//       '${AppConstants.baseUrl}/api/User/UserSummary';

//   static Future<bool> fetchAndSaveUsers() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);

//         for (var userJson in data) {
//           try {
//             final user = UserModel.fromApi(userJson);
//             await DBService.instance.insertUser(user);
//           } catch (e) {
//             print("Error inserting user: $e");
//           }
//         }
//         return true;
//       } else {
//         print("API Error: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print("Error importing users: $e");
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_tracking/utils/app_config.dart'; 
import '../models/user_model.dart';
import '../services/db_service.dart';

class UserImportService {
  static Future<bool> fetchAndSaveUsers() async {
    try {
      final baseUrl = await AppConfig.getBaseUrl(); 
      final apiUrl = Uri.parse('$baseUrl/api/User/UserSummary');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (var userJson in data) {
          try {
            final user = UserModel.fromApi(userJson);
            await DBService.instance.insertUser(user);
          } catch (e) {
            print("Error inserting user: $e");
          }
        }
        return true;
      } else {
        print("API Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error importing users: $e");
      return false;
    }
  }
}
