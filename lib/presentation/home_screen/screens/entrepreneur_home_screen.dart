import 'package:inovest/core/utils/index.dart';
import 'package:inovest/presentation/add_project_screen/screens/add_project_screen.dart';

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
        backgroundColor: AppArray().colors[1],
        title: Text(
          'My Projects',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.r),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is GetProfileloaded) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                          state.profileModel.data.imageUrl.toString()),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppArray().colors[2],
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProjectScreen(),
            ),
          );
          if (result == true) {
            _loadData();
          }
        },
        child: Icon(Icons.add, color: AppArray().colors[1]),
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
        child: BlocListener<IdeasBloc, IdeasState>(
          listener: (context, state) {
            if (state is IdeaDeleted) {
              _loadData();
            } else if (state is IdeasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Column(
            children: [
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppArray().colors[2].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: PopupMenuButton<String>(
                            color: AppArray().colors[1],
                            offset: Offset(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (status) {
                              context
                                  .read<EntrepreneurIdeasBloc>()
                                  .add(FilterEntrepreneurIdeas(status));
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'ALL',
                                child: Row(
                                  children: [
                                    Icon(Icons.list_alt, color: AppArray().colors[2], size: 20),
                                    SizedBox(width: 8.w),
                                    Text('All Projects'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'AVAILABLE',
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                                    SizedBox(width: 8.w),
                                    Text('Available'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'UNDER_DISCUSSION',
                                child: Row(
                                  children: [
                                    Icon(Icons.chat_outlined, color: Colors.orange, size: 20),
                                    SizedBox(width: 8.w),
                                    Text('Under Discussion'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'BOOKED',
                                child: Row(
                                  children: [
                                    Icon(Icons.bookmark_outline, color: Colors.blue, size: 20),
                                    SizedBox(width: 8.w),
                                    Text('Booked'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'INVESTED',
                                child: Row(
                                  children: [
                                    Icon(Icons.attach_money, color: Colors.purple, size: 20),
                                    SizedBox(width: 8.w),
                                    Text('Invested'),
                                  ],
                                ),
                              ),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  color: AppArray().colors[2],
                                  size: 20,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: AppArray().colors[2],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppArray().colors[2].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: PopupMenuButton<bool>(
                            color: AppArray().colors[1],
                            offset: Offset(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (ascending) {
                              context
                                  .read<EntrepreneurIdeasBloc>()
                                  .add(SortEntrepreneurIdeas(ascending));
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: true,
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_upward, color: AppArray().colors[2], size: 20),
                                    SizedBox(width: 8.w),
                                    Text('Name A-Z'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: false,
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_downward, color: AppArray().colors[2], size: 20),
                                    SizedBox(width: 8.w),
                                    Text('Name Z-A'),
                                  ],
                                ),
                              ),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sort,
                                  color: AppArray().colors[2],
                                  size: 20,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Sort',
                                  style: TextStyle(
                                    color: AppArray().colors[2],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                          return GestureDetector(
                            onHorizontalDragStart: idea.status != "AVAILABLE" ? (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Only available projects can be deleted',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.grey[700],
                                ),
                              );
                            } : null,
                            child: Dismissible(
                              key: Key(idea.id),
                              direction: idea.status == "AVAILABLE" 
                                  ? DismissDirection.endToStart 
                                  : DismissDirection.none,
                              background: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.w),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Project'),
                                      content: Text('Are you sure you want to delete this project?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                context.read<IdeasBloc>().add(DeleteIdea(id: idea.id));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                child: Card(
                                  color: Color(0xffFCFCFE),
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if (idea.status != "AVAILABLE") {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Only available projects can be edited',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.grey[700],
                                          ),
                                        );
                                        return;
                                      }
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddProjectScreen(
                                            projectToEdit: idea,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadData();
                                      }
                                    },
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              idea.title,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(idea.status),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              _getStatusText(idea.status),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ],
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
                                  ),
                                ),
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
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'AVAILABLE':
        return Colors.green;
      case 'UNDER_DISCUSSION':
        return Colors.orange;
      case 'BOOKED':
        return Colors.blue;
      case 'INVESTED':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'AVAILABLE':
        return 'Available';
      case 'UNDER_DISCUSSION':
        return 'Under Discussion';
      case 'BOOKED':
        return 'Booked';
      case 'INVESTED':
        return 'Invested';
      default:
        return status;
    }
  }
}
