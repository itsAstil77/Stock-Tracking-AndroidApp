// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';
// // import 'package:stock_tracking/models/item_model.dart';
// // import 'package:stock_tracking/models/stock_count_model.dart';
// // import 'package:stock_tracking/services/db_service.dart';

// // class QRScannerScreen extends StatefulWidget {
// //   const QRScannerScreen({super.key});

// //   @override
// //   State<QRScannerScreen> createState() => _QRScannerScreenState();
// // }

// // class _QRScannerScreenState extends State<QRScannerScreen> {
// //   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
// //   QRViewController? controller;
// //   String? qrText;

// //   @override
// //   void dispose() {
// //     controller?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Scan QR Code')),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // Show a square QR scanner area
// //             Container(
// //               width: 300,
// //               height: 300,
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.blue, width: 2),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: QRView(
// //                 key: qrKey,
// //                 onQRViewCreated: _onQRViewCreated,
// //                 overlay: QrScannerOverlayShape(
// //                   borderColor: Colors.green,
// //                   borderRadius: 10,
// //                   borderLength: 30,
// //                   borderWidth: 10,
// //                   cutOutSize: 250, // Size of actual scan area
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(qrText ?? 'Scan a code', style: const TextStyle(fontSize: 16)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _onQRViewCreated(QRViewController controller) {
// //     setState(() => this.controller = controller);
// //     controller.scannedDataStream.listen((scanData) async {
// //       controller.pauseCamera(); // Prevent multiple scans
// //       final scannedCode = scanData.code;

// //       final item = await DBService.instance.getItemByQrCode(scannedCode ?? '');

// //       if (item != null) {
// //         _showItemPopup(item);
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('No item found for QR: $scannedCode')),
// //         );
// //         controller.resumeCamera(); // Continue scanning
// //       }
// //     });
// //   }

// //   void _showItemPopup(ItemModel item) async {
// //     final TextEditingController countController =
// //         TextEditingController(text: '1');
// //     bool manualEntry = false;

// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return StatefulBuilder(
// //           builder: (context, setState) {
// //             return AlertDialog(
// //               title: Text('Item: ${item.name}'),
// //               content: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Text('Description: ${item.description ?? "N/A"}'),
// //                   Text('QR Code: ${item.qrCode}'),
// //                   Row(
// //                     children: [
// //                       Checkbox(
// //                         value: manualEntry,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             manualEntry = value ?? false;
// //                             if (!manualEntry) {
// //                               countController.text = '1';
// //                             }
// //                           });
// //                         },
// //                       ),
// //                       const Text("Manual Entry")
// //                     ],
// //                   ),
// //                   if (manualEntry)
// //                     TextField(
// //                       controller: countController,
// //                       keyboardType: TextInputType.number,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Enter count to add'),
// //                     ),
// //                 ],
// //               ),
// //               actions: [
// //                 TextButton(
// //                   onPressed: () async {
// //                     final inputCount =
// //                         int.tryParse(countController.text.trim());
// //                     if (inputCount == null || inputCount < 1) {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                             content:
// //                                 Text('Please enter a valid positive number.')),
// //                       );
// //                       return;
// //                     }

// //                     final now = DateTime.now().toIso8601String();
// //                     final lastCount =
// //                         await DBService.instance.getLatestStockCount(item.id!);
// //                     final newTotal = lastCount + inputCount;

// //                     await DBService.instance.insertStockCount(
// //                       StockCountModel(
// //                         itemId: item.id!,
// //                         barcode: item.qrCode, // Use QR code as barcode
// //                         description: item.description,
// //                         count: newTotal,
// //                         lastUpdated: now,
// //                       ),
// //                     );

// //                     Navigator.pop(context);
// //                     controller?.resumeCamera();

// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Count updated to $newTotal')),
// //                     );
// //                   },
// //                   child: const Text('Add Count'),
// //                 ),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                     controller?.resumeCamera();
// //                   },
// //                   child: const Text('Cancel'),
// //                 ),
// //               ],
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:stock_tracking/models/item_model.dart';
// import 'package:stock_tracking/models/stock_count_model.dart';
// import 'package:stock_tracking/services/db_service.dart';

// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String? qrText;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan QR Code')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue, width: 2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: QRView(
//                 key: qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//                 overlay: QrScannerOverlayShape(
//                   borderColor: Colors.green,
//                   borderRadius: 10,
//                   borderLength: 30,
//                   borderWidth: 10,
//                   cutOutSize: 250,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(qrText ?? 'Scan a code', style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() => this.controller = controller);
//     controller.scannedDataStream.listen((scanData) async {
//       controller.pauseCamera();
//       final scannedCode = scanData.code;

//       final item = await DBService.instance.getItemByQrCode(scannedCode ?? '');
//       if (item != null) {
//         _showItemPopup(item);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No item found for QR: $scannedCode')),
//         );
//         controller.resumeCamera();
//       }
//     });
//   }

//   void _showItemPopup(ItemModel item) async {
//     final TextEditingController countController = TextEditingController(text: '1');
//     bool manualEntry = false;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Item: ${item.name}'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Description: ${item.description ?? "N/A"}'),
//                   Text('QR Code: ${item.qrCode}'),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: manualEntry,
//                         onChanged: (value) {
//                           setState(() {
//                             manualEntry = value ?? false;
//                             if (!manualEntry) {
//                               countController.text = '1';
//                             }
//                           });
//                         },
//                       ),
//                       const Text("Manual Entry")
//                     ],
//                   ),
//                   if (manualEntry)
//                     TextField(
//                       controller: countController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(labelText: 'Enter count to add'),
//                     ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () async {
//                     final inputCount = int.tryParse(countController.text.trim());
//                     if (inputCount == null || inputCount < 1) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Please enter a valid positive number.')),
//                       );
//                       return;
//                     }

//                     final now = DateTime.now().toIso8601String();
//                     final updatedTotal = await DBService.instance.updateStockCount(
//                       itemId: item.id!,
//                       qrCode: item.qrCode,
//                       description: item.description,
//                       addCount: inputCount,
//                       updatedTime: now,
//                     );

//                     Navigator.pop(context);
//                     controller?.resumeCamera();

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Stock updated. New count: $updatedTotal')),
//                     );
//                   },
//                   child: const Text('Add Count'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     controller?.resumeCamera();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stock_tracking/models/item_model.dart';
import 'package:stock_tracking/services/db_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 250,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Scan a QR Code', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;

      isProcessing = true;
      controller.pauseCamera();

      final scannedCode = scanData.code?.trim();
      if (scannedCode == null || scannedCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR Code')),
        );
        controller.resumeCamera();
        isProcessing = false;
        return;
      }

      final item = await DBService.instance.getItemByQrCode(scannedCode);
      if (item != null) {
        _showItemPopup(item);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No item found for QR: $scannedCode')),
        );
        controller.resumeCamera();
        isProcessing = false;
      }
    });
  }

  void _showItemPopup(ItemModel item) {
    final TextEditingController countController = TextEditingController(text: '1');
    bool manualEntry = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Item: ${item.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Description: ${item.description ?? "N/A"}'),
                Text('QR Code: ${item.qrCode}'),
                Row(
                  children: [
                    Checkbox(
                      value: manualEntry,
                      onChanged: (value) {
                        setState(() {
                          manualEntry = value ?? false;
                          if (!manualEntry) {
                            countController.text = '1';
                          }
                        });
                      },
                    ),
                    const Text("Manual Entry")
                  ],
                ),
                if (manualEntry)
                  TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter count to add'),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final inputCount = int.tryParse(countController.text.trim());
                  if (inputCount == null || inputCount < 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid positive number.')),
                    );
                    return;
                  }

                  final now = DateTime.now().toIso8601String();

                  // Call the updated DBService to update or insert count
                  final updatedTotal = await DBService.instance.updateStockCount(
                    itemId: item.id!,
                    qrCode: item.qrCode,
                    description: item.description,
                    addCount: inputCount,
                    updatedTime: now,
                  );

                  Navigator.pop(context);
                  controller?.resumeCamera();
                  isProcessing = false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Stock updated to $updatedTotal')),
                  );
                },
                child: const Text('Add Count'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller?.resumeCamera();
                  isProcessing = false;
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
      },
    );
  }
}

