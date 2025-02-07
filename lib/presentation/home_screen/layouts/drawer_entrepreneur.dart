import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';

class EntrepreneurDrawer extends StatelessWidget {
  final String username;
  final String email;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;

  const EntrepreneurDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.onHomeTap,
    required this.onProfileTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      child: Container(
        color: AppArray().colors[1],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Material(
              elevation: 0, 
              color: AppArray().colors[1],
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: AppArray().colors[1],
                ),
                accountName: Text(
                  username,
                  style: TextStyle(color: AppArray().colors[5]),
                ),
                accountEmail:
                    Text(email, style: TextStyle(color: AppArray().colors[3])),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(username[0], style: TextStyle(fontSize: 40)),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email_outlined, color: AppArray().colors[5]),
              title: Text('Enquiries',
                  style: TextStyle(color: AppArray().colors[3])),
              onTap: onHomeTap,
              trailing: CircleAvatar(
                radius: 15,
                child: Text('2'),
              ),
            ),
            Divider(
              color: AppArray().colors[3],
              thickness: 0,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: AppArray().colors[5],
              ),
              title: Text('Settings',
                  style: TextStyle(color: AppArray().colors[3])),
              onTap: onProfileTap,
            ),
            Divider(
              color: AppArray().colors[3],
              thickness: 0,
            ),
            ListTile(
              leading: Icon(
                Icons.help_outline_outlined,
                color: AppArray().colors[5],
              ),
              title: Text('Settings',
                  style: TextStyle(color: AppArray().colors[3])),
              onTap: onSettingsTap,
            ),
            Divider(
              color: AppArray().colors[3],
              thickness: 0,
            ),
            ListTile(
              leading: Icon(
                Icons.stars_rounded,
                color: AppArray().colors[5],
              ),
              title: Text(
                'Leading',
                style: TextStyle(color: AppArray().colors[3]),
              ),
              onTap: onSettingsTap,
            ),
             Divider(
              color: AppArray().colors[3],
              thickness: 0,
            ),
            SizedBox(
              height: 250,
            ),
            Divider(
              color: AppArray().colors[5],
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppArray().colors[5]),
              title: Text(
                'Log out',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
