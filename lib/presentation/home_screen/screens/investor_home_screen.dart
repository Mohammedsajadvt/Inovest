import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_event.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_state.dart';
import 'package:inovest/business_logics/profile/profile_bloc.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/presentation/home_screen/layouts/drawer_investor.dart';
import 'package:inovest/presentation/ideas_screen/screens/ideas_screen.dart';

class InvestorHomeScreen extends StatefulWidget {
  const InvestorHomeScreen({super.key});

  @override
  _InvestorHomeScreenState createState() => _InvestorHomeScreenState();
}

class _InvestorHomeScreenState extends State<InvestorHomeScreen>
    with SingleTickerProviderStateMixin {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    print("Initializing InvestorHomeScreen...");
    _refreshData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  Future<void> _refreshData() async {
    final token = await SecureStorage().getToken();
    print("Token retrieved: $token");
    if (token != null) {
      context.read<ProfileBloc>().add(GetProfile());
      context.read<InvestorIdeasBloc>().add(GetInvestorIdeas());
      context.read<InvestorIdeasBloc>().add(GetInvestorCategories());
    } else {
      print("No token found, redirecting to login...");
      Navigator.of(context).pushReplacementNamed('/login');
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        print("Auto-refreshing data...");
        _refreshData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
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
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is GetProfileloaded) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10.r),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/profile');
                            },
                            child: CircleAvatar(
                              backgroundColor: AppArray().colors[1],
                              child: state.profileModel.data.imageUrl != null
                                  ? Image.network(
                                      state.profileModel.data.imageUrl!)
                                  : Icon(Icons.person,
                                      color: AppArray().colors[1]),
                            ),
                          ),
                        );
                      } else if (state is ProfileError) {
                        print("Profile Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
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
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                ),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
      drawer: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is GetProfileloaded) {
            return InvestorDrawer(
              username: state.profileModel.data.name,
              email: state.profileModel.data.email,
              imageUrl: state.profileModel.data.imageUrl ?? '',
              onHomeTap: () {},
              onProfileTap: () {},
              onSettingsTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocListener<InvestorIdeasBloc, InvestorIdeasState>(
        listener: (context, state) {
          if (state is GetCategoriesBasedIdeasLoaded) {
            Navigator.pop(context); // Close the loading dialog
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IdeasScreen(
                  title: state.categoryName ?? 'Ideas',
                  categoryId: state.ideas.data.isNotEmpty
                      ? state.ideas.data[0].categoryId
                      : '', // Use the categoryId from the first idea
                ),
              ),
            );
          } else if (state is InvestorIdeasError) {
            Navigator.pop(context); // Close the loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshData, // Manual pull-to-refresh
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Text(
                        'Explore',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                BlocBuilder<InvestorIdeasBloc, InvestorIdeasState>(
                  builder: (context, state) {
                    print("InvestorIdeasBloc State: $state");
                    if (state is InvestorIdeasLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppArray().colors[0],
                        ),
                      );
                    } else if (state is InvestorIdeasLoaded) {
                      final categories = state.investorCategories;
                      if (categories == null || categories.data.isEmpty) {
                        return const Center(
                            child: Text('No categories available'));
                      }

                      return SizedBox(
                        height: 50.h,
                        child: ListView.builder(
                          itemCount: categories.data.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemBuilder: (context, index) {
                            bool isFirstItem = index == 0;
                            int patternIndex = index < 2 ? 1 : (index - 2) % 2;

                            Color bgColor;
                            Color textColor;
                            Border? border;

                            if (isFirstItem || patternIndex == 0) {
                              bgColor = AppArray().colors[0];
                              textColor = AppArray().colors[1];
                              border = null;
                            } else {
                              bgColor = AppArray().colors[1];
                              textColor = AppArray().colors[0];
                              border = Border.all(
                                  color: AppArray().colors[0], width: 2.w);
                            }

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: CircularProgressIndicator(
                                        color: AppArray().colors[0]),
                                  ),
                                );
                                context.read<InvestorIdeasBloc>().add(
                                      CategoriesIdeas(
                                        categories.data[index].id,
                                        categoryName: categories.data[index].name,
                                      ),
                                    );
                              },
                              child: Container(
                                width: 140.w,
                                margin: EdgeInsets.only(right: 10.w),
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: border,
                                ),
                                child: Center(
                                  child: Text(
                                    categories.data[index].name.toUpperCase(),
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is InvestorIdeasError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('Pull to refresh'));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}