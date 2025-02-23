import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_state.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_event.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/data/models/categories_ideas.dart';

class IdeasScreen extends StatefulWidget {
  final String title;
  final String categoryId;

  const IdeasScreen({super.key, required this.title, required this.categoryId});

  @override
  _IdeasScreenState createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  @override
  void initState() {
    super.initState();
   // context.read<InvestorIdeasBloc>().add(GetCategoriesBasedIdeasLoaded(categoryName: widget.title));
    print("Initializing IdeasScreen for category: ${widget.title}");
  }

  Future<void> _onRefresh() async {
   // context.read<InvestorIdeasBloc>().add(GetCategoriesBasedIdeasLoaded(categoryName: widget.title));
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
          onPressed: () => Navigator.of(context).pop(true),
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
                onPressed: () { 
                 List<Datum> _ideas = [];
                  showSearch(
                    context: context,
                    delegate: IdeasSearchDelegate(_ideas),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<InvestorIdeasBloc, InvestorIdeasState>(
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
                return const Center(child: Text('No ideas available'));
              }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: ideas.data.length,
                itemBuilder: (context, index) {
                  final idea = ideas.data[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15).r,
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
                                idea.entrepreneur.imageUrl ?? '',
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.person, color: AppArray().colors[5]),
                              ),
                            ),
                            SizedBox(width: 12.r),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    idea.entrepreneur.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4.r),
                                  Text(
                                    idea.datumAbstract,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppArray().colors[5],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border_rounded,
                                color: AppArray().colors[5],
                                size: 24.h,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is InvestorIdeasError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Loading ideas...'));
          },
        ),
      ),
    );
  }
}
class IdeasSearchDelegate extends SearchDelegate {
  final List<Datum> ideas;

  IdeasSearchDelegate(this.ideas);

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredIdeas = ideas.where((idea) {
      final queryLower = query.toLowerCase();
      return idea.title.toLowerCase().contains(queryLower) ||
          idea.datumAbstract.toLowerCase().contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredIdeas.length,
      itemBuilder: (context, index) {
        final idea = filteredIdeas[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(idea.entrepreneur.imageUrl ?? ''),
            onBackgroundImageError: (_, __) => const Icon(Icons.person),
          ),
          title: Text(idea.entrepreneur.name),
          subtitle: Text(
            idea.datumAbstract,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => close(context, idea),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => query = '',
          ),
      ];
}
