import 'package:flutter/material.dart';

import 'list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfiletap;
  final void Function()? onSignOut;
  const MyDrawer(
      {super.key, required this.onProfiletap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),

              // home list tile
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),

              // user profile list tile
              MyListTile(
                  icon: Icons.person,
                  text: 'P R O F I L E',
                  onTap: onProfiletap),
            ],
          ),

          // logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
                icon: Icons.logout, text: 'L O G O U T', onTap: onSignOut),
          ),
        ],
      ),
    );
  }
}
