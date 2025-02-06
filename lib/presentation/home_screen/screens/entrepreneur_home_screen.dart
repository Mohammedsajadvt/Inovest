import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/core/common/svg_assets.dart';
import 'package:inovest/presentation/home_screen/layouts/drawer.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  const EntrepreneurHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[2],
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
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          title: Text("Add Project"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added: $title - $description")),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  },
  backgroundColor: AppArray().colors[1],
  foregroundColor: AppArray().colors[4],
  child: Icon(Icons.add),
),

      drawer: CustomDrawer(
        username: "John",
        email: "John@gmail.com",
        onHomeTap: () {},
        onProfileTap: () {},
        onSettingsTap: () {},
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Padding(
  padding: EdgeInsets.symmetric(horizontal: 15.w), // Ensure proper scaling for horizontal padding
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'My Projects',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
      Row(
        children: [
          Text(
            'Sort by',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          Icon(Icons.filter_alt),
        ],
      ),
    ],
  ),
),
Expanded(
  child: ListView.builder(
    itemCount: 10,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w), // Add padding for better spacing
          child: Column(
            mainAxisSize: MainAxisSize.min, // Allow dynamic height
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  Text('Rating: 5', style: TextStyle(fontSize: 12.sp)),
                ],
              ),
              SizedBox(height: 5.h), // Add spacing between title and description
              Text(
                'Description nnfnfnfnfnfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff',
                style: TextStyle(fontSize: 12.sp),
                softWrap: true,
              ),
            ],
          ),
        ),
      );
    },
  ),
),

        ],
      ),
    );
  }
}
