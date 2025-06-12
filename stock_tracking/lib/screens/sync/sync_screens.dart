// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:excel/excel.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path/path.dart' as path;
// import 'package:stock_tracking/constants/app_constants.dart';
// import '../../services/db_service.dart';
// import 'package:external_path/external_path.dart';

// import '../../models/stock_count_model.dart';

// class SyncScreen extends StatelessWidget {
//   const SyncScreen({super.key});

//   Future<bool> _requestStoragePermission(BuildContext context) async {
//     if (Platform.isAndroid) {
//       if (await Permission.manageExternalStorage.isGranted) {
//         return true;
//       }

//       final status = await Permission.manageExternalStorage.request();

//       if (status.isGranted) {
//         return true;
//       } else if (status.isPermanentlyDenied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Please enable storage permission in settings'),
//             action: SnackBarAction(
//               label: 'Settings',
//               onPressed: () => openAppSettings(),
//             ),
//           ),
//         );
//         return false;
//       }
//       return false;
//     }
//     return true;
//   }

//   Future<void> exportOffline(BuildContext context) async {
//     try {
//       final stockCounts = await DBService.instance.getAllStockCounts();
//       print('Stock counts retrieved: ${stockCounts.length}');

//       final excel = Excel.createExcel();
//       final defaultSheet = excel.getDefaultSheet(); 
//       excel.rename('Sheet1', 'StockCounts'); 
//       final sheet = excel['StockCounts'];

//       // Add header row with barcode and description
//       sheet.appendRow([
//         TextCellValue('Item ID'),
//         TextCellValue('Barcode'),
//         TextCellValue('Description'),
//         TextCellValue('Count'),
//         TextCellValue('Last Updated'),
//       ]);

//       // Add data rows with barcode and description
//       for (var stock in stockCounts) {
//         sheet.appendRow([
//           TextCellValue(stock.itemId),
//           TextCellValue(stock.barcode ?? ''),
//           TextCellValue(stock.description ?? ''),
//           IntCellValue(stock.count),
//           TextCellValue(stock.lastUpdated),
//         ]);
//       }

//       final fileBytes = excel.encode();
//       if (fileBytes == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to encode Excel file')),
//         );
//         print('File bytes are null');
//         return;
//       }

//       final dirPath = await ExternalPath.getExternalStoragePublicDirectory(
//           ExternalPath.DIRECTORY_DOWNLOAD);

//       if (dirPath == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to access storage directory')),
//         );
//         print('Directory path is null');
//         return;
//       }

//       // Add timestamp to avoid overwriting
//       final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
//       final filePath = path.join(dirPath, 'stock_counts_$timestamp.xlsx');
//       print('Saving file to: $filePath');

//       final file = File(filePath);
//       await file.writeAsBytes(fileBytes);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Excel saved to $filePath')),
//       );
//       print('File saved successfully');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error exporting to storage: $e')),
//       );
//       print('Error: $e');
//     }
//   }

//   Future<void> exportOnline(BuildContext context) async {
//     try {
//       final stockCounts = await DBService.instance.getAllStockCounts();

//       final excel = Excel.createExcel();
//       final defaultSheet = excel.getDefaultSheet(); 
//       excel.rename('Sheet1', 'StockCounts');
//       final sheet = excel['StockCounts'];

//       // Add header row with barcode and description
//       sheet.appendRow([
//         TextCellValue('Item ID'),
//         TextCellValue('Barcode'),
//         TextCellValue('Description'),
//         TextCellValue('quantity'),
//         TextCellValue('Last Updated'),
//       ]);

//       // Add data rows with barcode and description
//       for (var stock in stockCounts) {
//         sheet.appendRow([
//           TextCellValue(stock.itemId),
//           TextCellValue(stock.barcode ?? ''),
//           TextCellValue(stock.description ?? ''),
//           IntCellValue(stock.count),
//           TextCellValue(stock.lastUpdated),
//         ]);
//       }

//       final fileBytes = excel.encode();
//       if (fileBytes == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to encode Excel file')),
//         );
//         return;
//       }

//       final stockUploadUrl =
//           Uri.parse('${AppConstants.baseUrl}/api/Excel/StockUpload');
//       var request = http.MultipartRequest('POST', stockUploadUrl);

//       // Do NOT set Content-Type manually for multipart/form-data
//       request.headers['accept'] = '*/*';

//       request.files.add(http.MultipartFile.fromBytes(
//         'file',
//         fileBytes,
//         filename: 'stock_counts.xlsx',
//         contentType: MediaType(
//           'application',
//           'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
//         ),
//       ));

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Stock data uploaded successfully!')),
//         );
//       } else {
//         final respStr = await response.stream.bytesToString();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Upload failed: ${response.statusCode}\n$respStr')),
//         );
//         print('Response body: $respStr');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading file: $e')),
//       );
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     PlatformNavigator.setContext(context);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sync Stock Counts')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton.icon(
//               icon: const Icon(Icons.cloud_upload),
//               label: const Text("Export Online"),
//               onPressed: () => exportOnline(context),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.download),
//               label: const Text("Export Offline"),
//               onPressed: () => exportOffline(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlatformNavigator {
//   static BuildContext? _context;

//   static void setContext(BuildContext context) {
//     _context = context;
//   }

//   static BuildContext get context {
//     if (_context == null) {
//       throw Exception('Context not set. Call setContext first.');
//     }
//     return _context!;
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:stock_tracking/constants/app_constants.dart';
import '../../services/db_service.dart';
import 'package:external_path/external_path.dart';
import '../../models/stock_count_model.dart';
import '../../utils/app_config.dart'; 


class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enable storage permission in settings'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return false;
      }
      return false;
    }
    return true;
  }

  Future<void> exportOffline(BuildContext context) async {
    try {
      final stockCounts = await DBService.instance.getAllStockCounts();
      print('Stock counts retrieved: ${stockCounts.length}');

      final excel = Excel.createExcel();
      final defaultSheet = excel.getDefaultSheet();
      excel.rename('Sheet1', 'StockCounts');
      final sheet = excel['StockCounts'];

      sheet.appendRow([
        TextCellValue('Item ID'),
        TextCellValue('Barcode'),
        TextCellValue('Description'),
        TextCellValue('Count'),
        TextCellValue('CreatedDate'),
      ]);

      for (var stock in stockCounts) {
        sheet.appendRow([
          TextCellValue(stock.itemId),
          TextCellValue(stock.barcode ?? ''),
          TextCellValue(stock.description ?? ''),
          IntCellValue(stock.count),
          TextCellValue(stock.CreatedDate),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to encode Excel file')),
        );
        return;
      }

      final dirPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD);

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filePath = path.join(dirPath, 'stock_counts_$timestamp.xlsx');

      final file = File(filePath);
      await file.writeAsBytes(fileBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel saved to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting to storage: $e')),
      );
    }
  }

  Future<void> exportOnline(BuildContext context) async {
    try {
      final stockCounts = await DBService.instance.getAllStockCounts();

      final excel = Excel.createExcel();
      final defaultSheet = excel.getDefaultSheet();
      excel.rename('Sheet1', 'StockCounts');
      final sheet = excel['StockCounts'];

      sheet.appendRow([
        TextCellValue('Item ID'),
        TextCellValue('Barcode'),
        TextCellValue('Description'),
        TextCellValue('quantity'),
        TextCellValue('CreatedDate'),
      ]);

      for (var stock in stockCounts) {
        sheet.appendRow([
          TextCellValue(stock.itemId),
          TextCellValue(stock.barcode ?? ''),
          TextCellValue(stock.description ?? ''),
          IntCellValue(stock.count),
          TextCellValue(stock.CreatedDate),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to encode Excel file')),
        );
        return;
      }

      // final stockUploadUrl =
      //     Uri.parse('${AppConstants.baseUrl}/api/Excel/StockUpload');
      final baseUrl = await AppConfig.getBaseUrl();
      final stockUploadUrl = Uri.parse('$baseUrl/api/Excel/StockUpload');

      var request = http.MultipartRequest('POST', stockUploadUrl);

      request.headers['accept'] = '*/*';

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: 'stock_counts.xlsx',
        contentType: MediaType(
          'application',
          'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock data uploaded successfully!')),
        );
      } else {
        final respStr = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $respStr')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PlatformNavigator.setContext(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Stock Counts'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildExportTile(
                context,
                label: "Export Online",
                icon: Icons.cloud_upload,
                onTap: () => exportOnline(context),
                gradientColors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
              const SizedBox(height: 30),
              _buildExportTile(
                context,
                label: "Export Offline",
                icon: Icons.download,
                onTap: () => exportOffline(context),
                gradientColors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              offset: const Offset(0, 6),
              blurRadius: 10,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlatformNavigator {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext get context {
    if (_context == null) {
      throw Exception('Context not set. Call setContext first.');
    }
    return _context!;
  }
}






