import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          UserAccountsDrawerHeader(
            accountName: const Text("Mohmed Ahmed",
                style: TextStyle(fontSize: 18, color: Colors.black)),
            accountEmail: null,
            decoration: const BoxDecoration(color: Colors.white),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.w3schools.com/howto/img_avatar.png'), // Replace with actual user image
            ),
          ),

          // Drawer Items
          DrawerItem(icon: Icons.person, title: "Profile"),
          DrawerItem(icon: Icons.shopping_cart, title: "My Cart"),
          DrawerItem(icon: Icons.list_alt, title: "Orders"),
          DrawerItem(icon: Icons.notifications_none, title: "Notifications"),
          DrawerItem(icon: Icons.chat_bubble_outline, title: "Chat Bot"),
          DrawerItem(icon: Icons.sensors, title: "Sensors"),
          const Divider(),

          // Highlighted "About Us" Item
          DrawerItem(icon: Icons.info, title: "About us", isSelected: true),
          DrawerItem(icon: Icons.settings, title: "Settings"),

          const Spacer(),

          // Sign Out
          DrawerItem(icon: Icons.logout, title: "Sign Out"),
        ],
      ),
    );
  }
}

// Drawer Item Widget
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: ListTile(
          leading: Icon(icon, color: isSelected ? Colors.white : Colors.black),
          title: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
          onTap: () {
            // Add Navigation Here
          },
        ),
      ),
    );
  }
}
