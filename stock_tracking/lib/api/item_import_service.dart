// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stock_tracking/constants/app_constants.dart';
// import '../services/db_service.dart';
// import '../models/item_model.dart';

// class ItemImportService {
//   static const String apiUrl =
//       '${AppConstants.baseUrl}/api/Excel/ItemMasterSummary';

//   static Future<bool> fetchAndSaveItems() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);

//         for (var apiJson in data) {
//           try {
//             final item = ItemModel.fromApi(apiJson);
//             await DBService.instance.insertItem(item);
//           } catch (e) {
//             print("Error inserting item: $e");
//           }
//         }
//         return true;
//       } else {
//         print("API Error: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print("Error importing items: $e");
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_tracking/utils/app_config.dart'; // <-- UPDATED
import '../services/db_service.dart';
import '../models/item_model.dart';

class ItemImportService {
  static Future<bool> fetchAndSaveItems() async {
    try {
      final baseUrl = await AppConfig.getBaseUrl(); 
      final apiUrl = Uri.parse('$baseUrl/api/Excel/ItemMasterSummary');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (var apiJson in data) {
          try {
            final item = ItemModel.fromApi(apiJson);
            await DBService.instance.insertItem(item);
          } catch (e) {
            print("Error inserting item: $e");
          }
        }
        return true;
      } else {
        print("API Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error importing items: $e");
      return false;
    }
  }
}
