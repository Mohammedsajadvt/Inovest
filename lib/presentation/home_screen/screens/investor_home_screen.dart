import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/presentation/home_screen/layouts/drawer_entrepreneur.dart';
import 'package:inovest/presentation/home_screen/layouts/drawer_investor.dart';

class InvestorHomeScreen extends StatefulWidget {
  const InvestorHomeScreen({super.key});

  @override
  _InvestorHomeScreenState createState() => _InvestorHomeScreenState();
}

class _InvestorHomeScreenState extends State<InvestorHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final token = SecureStorage().getToken();


  @override
  Widget build(BuildContext context) {
  token.then((value) {
    print(value);
  },);
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[0],
        foregroundColor: AppArray().colors[1],
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        toolbarHeight: 200.h,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                Image.asset(
                  ImageAssets.logoWhite,
                  height: 100.r,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.r),
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: AppArray().colors[1],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: AppArray().colors[1],
                filled: true,
                hintText: 'Search',
                hintStyle: TextStyle(color: AppArray().colors[3]),
                suffixIcon: Icon(
                  Icons.search,
                  color: AppArray().colors[3],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              ),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
      drawer: InvestorDrawer(
        username: "John",
        email: "John@gmail.com",
        onHomeTap: () {},
        onProfileTap: () {},
        onSettingsTap: () {},
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Explore',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          TabBar(
            isScrollable: true,
            padding: EdgeInsets.only(right: 40),
            labelColor: AppArray().colors[1],
            indicatorColor: AppArray().colors[1],
            dividerColor: AppArray().colors[1],
            controller: _tabController,
            tabs: <Widget>[
              Container(
                width: 140.w,
                padding: EdgeInsets.symmetric(horizontal: 10).r,
                decoration: BoxDecoration(
                  color: AppArray().colors[0],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Tab(
                  child: Text(
                    'Tab 1',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 140.w,
                padding: EdgeInsets.symmetric(horizontal: 10).r,
                decoration: BoxDecoration(
                  color: AppArray().colors[1],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppArray().colors[0]),
                ),
                child: Tab(
                  child: Text(
                    'Tab 2',
                    style: TextStyle(
                      color: AppArray().colors[0],
                    ),
                  ),
                ),
              ),
              Container(
                width: 140.w,
                padding: EdgeInsets.symmetric(horizontal: 10).r,
                decoration: BoxDecoration(
                  color: AppArray().colors[0],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Tab(
                  child: Text(
                    'Tab 3',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                Center(child: Text('Content for Tab 1')),
                Center(child: Text('Content for Tab 2')),
                Center(child: Text('Content for Tab 3')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
