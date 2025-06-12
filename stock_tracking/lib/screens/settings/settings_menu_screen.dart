// import 'package:flutter/material.dart';
// import 'import_items_screen.dart';

// class SettingsMenuScreen extends StatelessWidget {
//   const SettingsMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.file_download),
//             title: const Text('Import Items'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ImportItemsScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'import_items_screen.dart';
// import 'import_users_screen.dart'; // <-- Add this import

// class SettingsMenuScreen extends StatelessWidget {
//   const SettingsMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.file_download),
//             title: const Text('Import Items'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ImportItemsScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.people),
//             title: const Text('Import Users'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ImportUsersScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'import_items_screen.dart';
import 'import_users_screen.dart';
import '../../utils/app_config.dart'; 

class SettingsMenuScreen extends StatefulWidget {
  const SettingsMenuScreen({super.key});

  @override
  State<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
  TextEditingController ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentIP();
  }

  Future<void> _loadCurrentIP() async {
    final currentIP = await AppConfig.getBaseUrl();
    ipController.text = currentIP;
  }

  Future<void> _saveIP() async {
    final ip = ipController.text.trim();
    if (ip.isNotEmpty) {
      await AppConfig.setBaseUrl(ip);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Base IP updated to $ip')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Import Items'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImportItemsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Import Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImportUsersScreen()),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Set Base IP", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: ipController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Base URL/IP',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _saveIP,
                  icon: const Icon(Icons.save),
                  label: const Text("Save IP"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


