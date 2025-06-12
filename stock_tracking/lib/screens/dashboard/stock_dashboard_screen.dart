// import 'package:flutter/material.dart';
// import '../../widgets/drawer_menu.dart';
// import '../qr/qr_scanner_screen.dart';
// import '../settings/settings_menu_screen.dart';

// class StockDashboardScreen extends StatefulWidget {
//   const StockDashboardScreen({super.key});

//   @override
//   State<StockDashboardScreen> createState() => _StockDashboardScreenState();
// }

// class _StockDashboardScreenState extends State<StockDashboardScreen> {
//   final List<_DashboardModule> modules = [
//     //_DashboardModule("Stock Count", Icons.storage, '/stockCount'),
//     _DashboardModule("Sync", Icons.sync, '/sync'),
//     _DashboardModule("Settings", Icons.settings, '/settingsMenu', isSettings: true),
//     _DashboardModule("QR Scanner", Icons.qr_code_scanner, null, isQr: true),
//     _DashboardModule("Logout", Icons.logout, '/', isLogout: true),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       drawer: const DrawerMenu(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: modules.map((module) {
//             return GestureDetector(
//               onTap: () {
//                 if (module.isLogout) {
//                   Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
//                 } else if (module.isQr) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const QRScannerScreen()),
//                   );
//                 } else if (module.isSettings) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const SettingsMenuScreen()),
//                   );
//                 } else {
//                   Navigator.pushNamed(context, module.route!);
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 6,
//                       offset: const Offset(2, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(module.icon, size: 40, color: Colors.blue),
//                     const SizedBox(height: 12),
//                     Text(
//                       module.title,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

// class _DashboardModule {
//   final String title;
//   final IconData icon;
//   final String? route;
//   final bool isQr;
//   final bool isLogout;
//   final bool isSettings;

//   _DashboardModule(this.title, this.icon, this.route,
//       {this.isQr = false, this.isLogout = false, this.isSettings = false});
// }

import 'package:flutter/material.dart';
import '../../widgets/drawer_menu.dart';
import '../qr/qr_scanner_screen.dart';
import '../settings/settings_menu_screen.dart';

class StockDashboardScreen extends StatefulWidget {
  const StockDashboardScreen({super.key});

  @override
  State<StockDashboardScreen> createState() => _StockDashboardScreenState();
}

class _StockDashboardScreenState extends State<StockDashboardScreen> {
  final List<_DashboardModule> modules = [
    _DashboardModule("Sync", Icons.sync, '/sync'),
    _DashboardModule("Settings", Icons.settings, '/settingsMenu', isSettings: true),
    _DashboardModule("QR Scanner", Icons.qr_code_scanner, null, isQr: true),
    _DashboardModule("Logout", Icons.logout, '/', isLogout: true),
  ];

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        elevation: 4,
        title: const Text('Stock-Tracking'),
        backgroundColor: Colors.deepPurple,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF4F5F9), Color(0xFFEAEAF2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: modules.map((module) {
                return _buildModuleCard(context, module);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, _DashboardModule module) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (module.isLogout) {
          _showLogoutDialog();
        } else if (module.isQr) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const QRScannerScreen()));
        } else if (module.isSettings) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsMenuScreen()));
        } else {
          Navigator.pushNamed(context, module.route!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFEEF1F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple.shade100,
              child: Icon(module.icon, size: 30, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Text(
              module.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardModule {
  final String title;
  final IconData icon;
  final String? route;
  final bool isQr;
  final bool isLogout;
  final bool isSettings;

  _DashboardModule(this.title, this.icon, this.route,
      {this.isQr = false, this.isLogout = false, this.isSettings = false});
}

