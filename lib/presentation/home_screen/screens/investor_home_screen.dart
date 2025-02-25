import 'package:inovest/core/utils/index.dart';

import '../index.dart';

class InvestorHomeScreen extends StatefulWidget {
  const InvestorHomeScreen({super.key});

  @override
  _InvestorHomeScreenState createState() => _InvestorHomeScreenState();
}

class _InvestorHomeScreenState extends State<InvestorHomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    print("Initializing InvestorHomeScreen...");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
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
            Navigator.pop(context);
            _navigateToIdeasScreen(
              state.ideas.data != null && state.ideas.data!.isNotEmpty
                  ? state.ideas.data![0].categoryId
                  : '',
              state.categoryName ?? 'Ideas',
            );
          } else if (state is InvestorIdeasError) {
            Navigator.pop(context);
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
                    if (state is InvestorIdeasLoaded) {
                      final categories = state.investorCategories;
                      if (categories == null || categories.data.isEmpty) {
                        return const Center(
                            child: Text('No categories available'));
                      } else if (state is InvestorIdeasLoading) {
                        return SizedBox.shrink();
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
                            Color bgColor = isFirstItem || patternIndex == 0
                                ? AppArray().colors[0]
                                : AppArray().colors[1];
                            Color textColor = isFirstItem || patternIndex == 0
                                ? AppArray().colors[1]
                                : AppArray().colors[0];
                            Border? border = isFirstItem || patternIndex == 0
                                ? null
                                : Border.all(
                                    color: AppArray().colors[0], width: 2.w);

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
                                        categoryId: categories.data[index].id,
                                        categoryName:
                                            categories.data[index].name,
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
                                        color: textColor, fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is InvestorIdeasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: Text('Error: ${state.message}')),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 3.w, color: AppArray().colors[0])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 10).r,
                          child: Text(
                            'Top 5',
                            style: TextStyle(
                                fontSize: 20.sp, color: AppArray().colors[0]),
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
                          final colors = [Colors.yellow, Colors.tealAccent];

                          final ScrollController _scrollController =
                              ScrollController();

                          return Column(
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
                                        fontSize: 20.sp,
                                        color: AppArray().colors[3],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_scrollController.hasClients) {
                                          double currentPosition =
                                              _scrollController.offset;
                                          double cardWidth =
                                              130.0; 
                                          double nextPosition =
                                              currentPosition + cardWidth;

                                          if (nextPosition <=
                                              _scrollController
                                                  .position.maxScrollExtent) {
                                            _scrollController.animateTo(
                                              nextPosition,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        }
                                      },
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                color: colors[index % colors.length],
                                child: SizedBox(
                                  height: 160.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    controller:
                                        _scrollController,
                                    itemCount: categoryIdeas.length,
                                    itemBuilder: (context, ideaIndex) {
                                      final idea = categoryIdeas[ideaIndex];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.r),
                                        child: SizedBox(
                                          width:
                                              130.w, 
                                          child: Card(
                                            color: AppArray().colors[1],
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                      left: 6, right: 6)
                                                  .r,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 10.h),
                                                  Text(
                                                    idea.title,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Color(0xff27285B),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Text(
                                                    idea.datumAbstract,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Color(0xff797878),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Know more',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xff27285B)),
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
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
