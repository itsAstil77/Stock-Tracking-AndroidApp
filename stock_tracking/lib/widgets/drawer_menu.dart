// import 'package:flutter/material.dart';

// class DrawerMenu extends StatelessWidget {
//   const DrawerMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(color: Colors.deepPurple),
//             child: Center(
//               child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Dashboard'),
//             onTap: () => Navigator.pop(context),
//           ),
          
//           ListTile(
//             leading: const Icon(Icons.sync),
//             title: const Text('Sync'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/sync');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () {
//               Navigator.popUntil(context, (route) => route.isFirst);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ListTile(
//           //   leading: const Icon(Icons.storage),
//           //   title: const Text('Stock Count'),
//           //   onTap: () {
//           //     Navigator.pop(context);
//           //     Navigator.pushNamed(context, '/stockCount');
//           //   },
//           // ),

import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  void _confirmLogout(BuildContext context) {
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
    return Drawer(
      backgroundColor: const Color(0xFFF4F5F9),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text("Stock_Tracking", style: TextStyle(fontSize: 18)),
            accountEmail: const Text("manager@stockapp.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/user.png'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildDrawerTile(
                  context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  routeName: '/dashboard',
                ),
                // _buildDrawerTile(
                //   context,
                //   icon: Icons.storage,
                //   label: 'Stock Count',
                //   routeName: '/stockCount',
                // ),
                _buildDrawerTile(
                  context,
                  icon: Icons.sync,
                  label: 'Sync',
                  routeName: '/sync',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.settings,
                  label: 'Settings',
                  routeName: '/settings',
                ),
                const Divider(height: 30, thickness: 1),
                _buildDrawerTile(
                  context,
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () => _confirmLogout(context),
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? routeName,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade50,
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap ??
            () {
              Navigator.pop(context);
              if (routeName != null) {
                Navigator.pushNamed(context, routeName);
              }
            },
      ),
    );
  }
}

