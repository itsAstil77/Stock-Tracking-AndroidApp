// import 'package:flutter/material.dart';
// import 'package:stock_tracking/services/db_service.dart';
// import '../../api/item_import_service.dart';

// class ImportItemsScreen extends StatelessWidget {
//   const ImportItemsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Import Items')),
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: const Icon(Icons.download),
//           label: const Text("Import Item Master"),
//           onPressed: () async {
//             // Show loading indicator while importing
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (_) => const Center(child: CircularProgressIndicator()),
//             );

//             final success = await ItemImportService.fetchAndSaveItems();

//             // Close loading dialog
//             Navigator.of(context).pop();

//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   success
//                       ? "Items imported successfully!"
//                       : "Failed to import items. Please try again.",
//                 ),
//                 backgroundColor: success ? Colors.green : Colors.red,
//                 duration: const Duration(seconds: 3),
//               ),
//             );

//             DBService.instance.getItems();
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:stock_tracking/services/db_service.dart';
import '../../api/item_import_service.dart';

class ImportItemsScreen extends StatefulWidget {
  const ImportItemsScreen({super.key});

  @override
  State<ImportItemsScreen> createState() => _ImportItemsScreenState();
}

class _ImportItemsScreenState extends State<ImportItemsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Items'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_download, size: 60, color: Colors.deepPurple),
                  const SizedBox(height: 20),
                  const Text(
                    'Import Item Master',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Click the button below to fetch and store item data.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Loader shown above button
                  if (_isLoading) ...[
                    const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),
                  ],

                  ElevatedButton.icon(
                    icon: const Icon(Icons.system_update_alt),
                    label: const Text("Start Import"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isLoading ? null : _importItems,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _importItems() async {
    setState(() => _isLoading = true);

    final success = await ItemImportService.fetchAndSaveItems();

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "✅ Items imported successfully!"
              : "❌ Failed to import items. Please try again.",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await DBService.instance.getItems();
  }
}

