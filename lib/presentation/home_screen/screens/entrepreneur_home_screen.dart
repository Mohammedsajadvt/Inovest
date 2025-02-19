import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/business_logics/category/category_bloc.dart';
import 'package:inovest/business_logics/category/category_event.dart';
import 'package:inovest/business_logics/category/category_state.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/presentation/home_screen/layouts/drawer_entrepreneur.dart';

class EntrepreneurHomeScreen extends StatefulWidget {
  const EntrepreneurHomeScreen({super.key});

  @override
  State<EntrepreneurHomeScreen> createState() => _EntrepreneurHomeScreenState();
}

class _EntrepreneurHomeScreenState extends State<EntrepreneurHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetCategoriesBloc>().add(FetchCategoriesEvent());
  }

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
              onChanged: (value) {
                context.read<GetCategoriesBloc>().add(SearchCategoriesEvent(query: value));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/project');
        },
        backgroundColor: AppArray().colors[1],
        foregroundColor: AppArray().colors[4],
        child: Icon(Icons.add),
      ),
      drawer: EntrepreneurDrawer(
        username: "John",
        email: "John@gmail.com",
        onHomeTap: () {},
        onProfileTap: () {},
        onSettingsTap: () {},
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GetCategoriesBloc>().add(FetchCategoriesEvent());
        },
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Projects',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  PopupMenuButton<bool>(
                    onSelected: (ascending) {
                      context.read<GetCategoriesBloc>().add(SortCategoriesEvent(ascending));
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: true,
                        child: Text('Name Ascending'),
                      ),
                      PopupMenuItem(
                        value: false,
                        child: Text('Name Descending'),
                      ),
                    ],
                    child: Row(
                      children: [
                        Text(
                          'Sort by',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                        Icon(Icons.filter_alt),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
                builder: (context, state) {
                  if (state is GetCategoryLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetCategoryLoaded) {
                    return ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return Card(
                          shape: Border.all(color: const Color(0xffFCFCFE)),
                          color: const Color(0xffFCFCFE),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const Text('Rating: 5⭐'),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Text(category.description),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is GetCategoryError) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
