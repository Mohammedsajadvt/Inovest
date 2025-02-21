import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_event.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_state.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/index.dart';

class IdeasScreen extends StatefulWidget {
  final String title;
  final String categoryId;

  const IdeasScreen({super.key, required this.title, required this.categoryId});

  @override
  _IdeasScreenState createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  Timer? _autoRefreshTimer;
  bool _isRefreshing = false; // To prevent overlapping refreshes

  @override
  void initState() {
    super.initState();
    print("Initializing IdeasScreen for category: ${widget.title}");
    _refreshData(); // Initial data load
    _startAutoRefresh(); // Start auto-refresh
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return; // Prevent overlapping refreshes
    setState(() => _isRefreshing = true);

    try {
      final token = await SecureStorage().getToken();
      print("Token retrieved: $token");
      if (token != null) {
        context.read<InvestorIdeasBloc>().add(
              CategoriesIdeas(
                widget.categoryId,
                categoryName: widget.title,
              ),
            );
      } else {
        print("No token found, redirecting to login...");
        Navigator.of(context).pushReplacementNamed('/login');
      }
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    } catch (e) {
      print("Refresh error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refresh failed: $e')),

      );
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel(); 
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && !_isRefreshing) {
        print("Auto-refreshing ideas for category: ${widget.title}");
        _refreshData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        backgroundColor: AppArray().colors[0],
        foregroundColor: AppArray().colors[1],
        leading: IconButton(
          onPressed: () {
            _autoRefreshTimer?.cancel(); // Stop auto-refresh on back press
            Navigator.of(context).pop(); // Pop back to InvestorHomeScreen
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        toolbarHeight: 80.h,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircleAvatar(
              backgroundColor: AppArray().colors[1],
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData, // Manual pull-to-refresh
        child: Stack(
          children: [
            BlocBuilder<InvestorIdeasBloc, InvestorIdeasState>(
              builder: (context, state) {
                print("IdeasScreen State: $state");
                if (state is InvestorIdeasLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppArray().colors[0],
                    ),
                  );
                } else if (state is GetCategoriesBasedIdeasLoaded) {
                  final ideas = state.ideas;
                  if (ideas == null || ideas.data.isEmpty) {
                    return const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(child: Text('No ideas available')),
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: ideas.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15).r,
                        child: Card(
                          color: const Color(0xffe3e8fb),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(12).r,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Image.network(
                                    ideas.data[index].entrepreneur.imageUrl ?? '',
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.person,
                                          color: AppArray().colors[5]);
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.r),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ideas.data[index].entrepreneur.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4.r),
                                      Text(
                                        ideas.data[index].datumAbstract,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppArray().colors[5],
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.r),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.favorite_border_rounded,
                                          color: AppArray().colors[5], size: 24.h),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is InvestorIdeasError) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(child: Text('Error: ${state.message}')),
                  );
                }
                return const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(child: Text('Loading ideas...')),
                );
              },
            ),
            if (_isRefreshing)
              Center(
                child: CircularProgressIndicator(color: AppArray().colors[0]),
              ),
          ],
        ),
      ),
    );
  }
}