import 'package:inovest/core/utils/index.dart';
import 'package:inovest/core/app_settings/unauthorized_notifier.dart';

import '../index.dart';

class InvestorHomeScreen extends StatefulWidget {
  const InvestorHomeScreen({super.key});

  @override
  _InvestorHomeScreenState createState() => _InvestorHomeScreenState();
}

class _InvestorHomeScreenState extends State<InvestorHomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    print("Initializing InvestorHomeScreen...");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });

    UnauthorizedNotifier().onUnauthorized.listen((_) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    print("Loading data in InvestorHomeScreen...");
    context.read<ProfileBloc>().add(GetProfile());
    context.read<InvestorIdeasBloc>().add(GetInvestorIdeas());
    context.read<InvestorIdeasBloc>().add(GetInvestorCategories());
  }

  void _navigateToIdeasScreen(String categoryId, String categoryName) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IdeasScreen(
          title: categoryName,
          categoryId: categoryId,
        ),
      ),
    );

    if (result == true) {
      print("Returned from IdeasScreen, triggering refresh...");
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SecureStorage().getToken().then((token) {
      print(' My Token ${token}');
    });
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
                                      state.profileModel.data.imageUrl!,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Icon(
                                          Icons.person,
                                          color: AppArray().colors[1],
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          color: AppArray().colors[1],
                                        );
                                      },
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: AppArray().colors[1],
                                    ),
                            ),
                          ),
                        );
                      } else if (state is ProfileError) {
                        print("Profile Error: ${state.message}");
                      }
                      return Padding(
                        padding: EdgeInsets.only(right: 10.r),
                        child: CircleAvatar(
                          backgroundColor: AppArray().colors[1],
                        ),
                      );
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
                  suffixIcon: Icon(Icons.search, color: AppArray().colors[3]),
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
                onChanged: (value) {
                  setState(() {
                    _isSearching = value.isNotEmpty;
                  });
                  context.read<InvestorIdeasBloc>().add(SearchInvestorIdeas(query: value));
                },
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
          if (state is InvestorIdeasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: RefreshIndicator(
          color: AppArray().colors[5],
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (!_isSearching) ...[
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
                      if (state is InvestorIdeasLoaded && 
                          state.investorCategories != null) {
                        final categories = state.investorCategories!;
                        if (categories.data!.isEmpty) {
                          return const Center(
                              child: Text('No categories available'));
                        }
                        return SizedBox(
                          height: 56.h,
                          child: ListView.builder(
                            itemCount: categories.data.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemBuilder: (context, index) {
                              bool isFilledStyle = index % 2 == 1;
                              final category = categories.data[index];
                              
                              return Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => IdeasScreen(
                                          title: category.name,
                                          categoryId: category.id,
                                          shouldLoadOnInit: true,
                                        ),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadData();
                                    }
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth: 120.w,
                                      maxWidth: 200.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFilledStyle ? AppArray().colors[0] : Colors.transparent,
                                      border: Border.all(
                                        color: AppArray().colors[0],
                                        width: 2.w,
                                      ),
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                                        child: Text(
                                          category.name.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isFilledStyle ? AppArray().colors[1] : AppArray().colors[0],
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                              width: 2.w, color: AppArray().colors[0])),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h).r,
                            child: Text(
                              'Top 5',
                              style: TextStyle(
                                  fontSize: 20.sp, 
                                  fontWeight: FontWeight.w600,
                                  color: AppArray().colors[0]),
                            ),
                          ),
                          BlocBuilder<InvestorIdeasBloc, InvestorIdeasState>(
                            builder: (context, state) {
                              if (state is InvestorIdeasLoaded) {
                                if (state.topIdeas != null &&
                                    state.topIdeas!.data != null &&
                                    state.topIdeas!.data!.isNotEmpty) {
                                  final sortedData =
                                      List.from(state.topIdeas!.data!)
                                        ..sort((a, b) {
                                          final aRatings = a.count?.ratings ?? 0;
                                          final bRatings = b.count?.ratings ?? 0;
                                          final ratingComparison =
                                              bRatings.compareTo(aRatings);
                                          if (ratingComparison != 0)
                                            return ratingComparison;
                                          return b.createdAt
                                              .compareTo(a.createdAt);
                                        });

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: min(5, sortedData.length),
                                    itemBuilder: (context, index) {
                                      final data = sortedData[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                                left: 10, right: 10)
                                            .r,
                                        child: Card(
                                          color: AppArray().colors[1],
                                          elevation: 2,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  data.entrepreneur?.imageUrl !=
                                                          null
                                                      ? NetworkImage(data
                                                          .entrepreneur!
                                                          .imageUrl!)
                                                      : null,
                                            ),
                                            title: Text(
                                              data.entrepreneur?.name != null
                                                  ? data.entrepreneur.name!
                                                  : 'Unknown',
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text((data.count?.ratings ?? 0)
                                                    .toString()),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                              left: 10, right: 10)
                                          .r,
                                      child: Card(
                                        color: AppArray().colors[1],
                                        elevation: 2,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.grey[300] ??
                                                AppArray().colors[1],
                                          ),
                                          title: Container(
                                            height: 16,
                                            color: Colors.grey[300],
                                          ),
                                          subtitle: Container(
                                            height: 14,
                                            color: Colors.grey[300],
                                          ),
                                          trailing: Container(
                                            height: 16,
                                            width: 16,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<InvestorIdeasBloc, InvestorIdeasState>(
                    builder: (context, state) {
                      if (state is InvestorIdeasLoaded) {
                        if (state.topIdeas == null ||
                            state.topIdeas!.data == null) {
                          return const Center(child: Text('No ideas available'));
                        }

                        final Map<String, List<Datum>> groupedIdeas = {};
                        for (var idea in state.topIdeas!.data!) {
                          if (idea.category != null) {
                            groupedIdeas.putIfAbsent(idea.category!.id, () => []);
                            groupedIdeas[idea.category!.id]!.add(idea);
                          }
                        }

                        final uniqueCategories = groupedIdeas.keys
                            .map((categoryId) => state.topIdeas!.data!
                                .firstWhere(
                                    (idea) => idea.category?.id == categoryId)
                                .category!)
                            .toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: uniqueCategories.length,
                          itemBuilder: (context, index) {
                            final category = uniqueCategories[index];
                            final categoryIdeas = groupedIdeas[category.id] ?? [];
                            final colors = [
                              Color(0xFFFFF8E1),
                              Color(0xFFE0F2F1),
                              Color(0xFFF3E5F5),
                              Color(0xFFE8F5E9),
                            ];

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          category.name,
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppArray().colors[0],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => IdeasScreen(
                                                  title: category.name,
                                                  categoryId: category.id,
                                                  shouldLoadOnInit: true,
                                                ),
                                              ),
                                            );
                                            if (result == true) {
                                              _loadData();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.r),
                                            decoration: BoxDecoration(
                                              color: AppArray().colors[0],
                                              borderRadius: BorderRadius.circular(30.r),
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: AppArray().colors[1],
                                              size: 20.r,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors[index % colors.length],
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: SizedBox(
                                      height: 200.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categoryIdeas.length,
                                        itemBuilder: (context, ideaIndex) {
                                          final idea = categoryIdeas[ideaIndex];
                                          return Container(
                                            width: 250.w,
                                            margin: EdgeInsets.only(right: 15.w),
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.r),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15.r),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      AppArray().colors[1],
                                                      AppArray().colors[1].withValues(alpha: 229),
                                                    ],
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.r),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        idea.title,
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppArray().colors[0],
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Text(
                                                        idea.datumAbstract,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: AppArray().colors[3],
                                                          height: 1.2,
                                                        ),
                                                        maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: AppArray().colors[0],
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.r),
                                                            ),
                                                            padding: EdgeInsets.symmetric(vertical: 10.h),
                                                          ),
                                                          child: Text(
                                                            'Know more',
                                                            style: TextStyle(
                                                              color: AppArray().colors[1],
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ] else ...[
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: BlocBuilder<InvestorIdeasBloc, InvestorIdeasState>(
                      builder: (context, state) {
                        if (state is InvestorIdeasLoaded && state.topIdeas?.data != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search Results',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppArray().colors[0],
                                ),
                              ),
                              SizedBox(height: 15.h),
                              state.topIdeas!.data!.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No results found',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppArray().colors[3],
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state.topIdeas!.data!.length,
                                      itemBuilder: (context, index) {
                                        final idea = state.topIdeas!.data![index];
                                        return Card(
                                          margin: EdgeInsets.only(bottom: 15.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(15.r),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  idea.title,
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppArray().colors[0],
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  idea.datumAbstract,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: AppArray().colors[3],
                                                  ),
                                                ),
                                                if (idea.category != null) ...[
                                                  SizedBox(height: 8.h),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w,
                                                      vertical: 6.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppArray().colors[0],
                                                      borderRadius: BorderRadius.circular(20.r),
                                                    ),
                                                    child: Text(
                                                      idea.category!.name,
                                                      style: TextStyle(
                                                        color: AppArray().colors[1],
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
