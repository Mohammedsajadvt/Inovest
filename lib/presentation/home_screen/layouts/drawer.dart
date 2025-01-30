import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;

  const CustomDrawer({super.key, 
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
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppArray().colors[1],
                border: Border(bottom: BorderSide(color:AppArray().colors[3],width: 0)),
                boxShadow: [],
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
            SizedBox(height: 250,),
            Divider(
              color: AppArray().colors[5],
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
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
