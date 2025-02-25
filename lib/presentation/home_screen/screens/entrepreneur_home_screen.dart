import 'package:inovest/core/utils/index.dart';

import '../index.dart';

class EntrepreneurHomeScreen extends StatefulWidget {
  const EntrepreneurHomeScreen({Key? key}) : super(key: key);

  @override
  State<EntrepreneurHomeScreen> createState() => _EntrepreneurHomeScreenState();
}

class _EntrepreneurHomeScreenState extends State<EntrepreneurHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<EntrepreneurIdeasBloc>().add(GetEntrepreneurIdeas());
    context.read<ProfileBloc>().add(GetProfile());
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
                                ? Image.network(state.profileModel.data.imageUrl!)
                                : Icon(Icons.person, color: AppArray().colors[1]),
                          ),
                        ),
                      );
                    } else if (state is ProfileError) {
                      print(state.message);
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
              onChanged: (value) {
                context
                    .read<EntrepreneurIdeasBloc>()
                    .add(SearchEntrepreneurIdeas(value));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppArray().colors[1],
        onPressed: () => Navigator.pushNamed(context, '/project'),
        child:  Icon(Icons.add,color: AppArray().colors[5],),
      ),
      drawer: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is GetProfileloaded) {
            return EntrepreneurDrawer(
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
      body: RefreshIndicator(
        color: AppArray().colors[5],
        onRefresh: () async => _loadData(),
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  PopupMenuButton<bool>(
                    color: AppArray().colors[1],
                    onSelected: (ascending) {
                      context
                          .read<EntrepreneurIdeasBloc>()
                          .add(SortEntrepreneurIdeas(ascending));
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: true,
                        child: Text('Name Ascending'),
                      ),
                      const PopupMenuItem(
                        value: false,
                        child: Text('Name Descending'),
                      ),
                    ],
                    child: Row(
                      children: [
                        Text(
                          'Sort by',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                        const Icon(Icons.filter_alt),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<EntrepreneurIdeasBloc, EntrepreneurIdeasState>(
                builder: (context, state) {
                  if (state is EntrepreneurIdeasLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EntrepreneurIdeasLoaded) {
                    return ListView.builder(
                      itemCount: state.displayedIdeas.length,
                      itemBuilder: (context, index) {
                        final idea = state.displayedIdeas[index];
                        return Card(
                          color: Color(0xffFCFCFE),
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: ListTile(
                            title: Text(
                              idea.title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(idea.abstract),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      'Category: ${idea.category.name}',
                                      style: TextStyle(
                                          color: AppArray().colors[5]),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Investment: \$${idea.expectedInvestment}',
                                      style: TextStyle(
                                          color: AppArray().colors[3]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 16.r, color: Colors.amber),
                                    Text(' ${idea.counts.ratings}'),
                                    SizedBox(width: 16.w),
                                    Icon(Icons.favorite,
                                        size: 16.r, color: Colors.red),
                                    Text(' ${idea.counts.interests}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is EntrepreneurIdeasError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No ideas found'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}