import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/pages/login_page.dart';
import '../utils/themes.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  late String? mail, name;
  var auth = Authentication();

  @override
  Widget build(BuildContext context) {
    mail = auth.currentUser?.email;
    name = auth.currentUser?.displayName;
    return Drawer(
      backgroundColor: MyTheme.lightColor,
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              margin: const EdgeInsets.all(0),
              accountName: Text(
                "$name",
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                "$mail",
                style: const TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    Authentication().currentUser?.photoURL == null
                        ? "assets/images/avatar1.png"
                        : Authentication().currentUser?.photoURL as String),
              ),
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  ModalRoute.withName('/'),
                );
              },
              leading: Icon(CupertinoIcons.home, color: Colors.white),
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/editprofile");
              },
              leading:
                  Icon(CupertinoIcons.profile_circled, color: Colors.white),
              title: Text(
                "Profile",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
                onTap: (() async {
                  await Authentication().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    ModalRoute.withName('/'),
                  );
                }),
                leading: Icon(CupertinoIcons.chevron_left_square_fill,
                    color: Colors.white),
                title: Text(
                  "Logout",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
