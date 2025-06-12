import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import
import 'package:stock_tracking/screens/sync/sync_screens.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard/stock_dashboard_screen.dart';
import 'screens/settings/settings_menu_screen.dart';
import 'screens/settings/import_items_screen.dart';
import 'screens/qr/qr_scanner_screen.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized

  // Request storage permissions at app startup (optional)
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle permission denial (e.g., show a dialog or limit functionality)
      print('Storage permission denied');
      // Optionally, you can navigate to a screen explaining why permissions are needed
    }
  }

  runApp(const StockTrackingApp());
}

class StockTrackingApp extends StatelessWidget {
  const StockTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.purpleAccent),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const StockDashboardScreen(),
        '/settings': (context) => const SettingsMenuScreen(),
        '/importItems': (context) => const ImportItemsScreen(),
        '/qrScanner': (context) => const QRScannerScreen(),
        '/sync': (context) => const SyncScreen(),
      },
    );
  }
}
