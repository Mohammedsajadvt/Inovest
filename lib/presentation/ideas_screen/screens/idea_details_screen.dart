import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/data/services/investor_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:inovest/core/utils/navigation_helper.dart';
import 'package:inovest/core/utils/user_utils.dart';
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/business_logics/chat/chat_event.dart';
import 'package:inovest/business_logics/chat/chat_state.dart';
import 'package:inovest/presentation/chat/screens/chat_detail_screen.dart';

class IdeaDetailsScreen extends StatefulWidget {
  final String ideaId;

  const IdeaDetailsScreen({
    Key? key,
    required this.ideaId,
  }) : super(key: key);

  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  late Future<Map<String, dynamic>> _ideaDetailsFuture;
  final InvestorService _investorService = InvestorService();
  int _currentRating = 0;
  Map<String, dynamic>? _currentIdeaData;
  final TextEditingController _commentController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _ideaDetailsFuture = _investorService.getIdeaDetails(widget.ideaId);
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final userId = await UserUtils.getCurrentUserId();
    setState(() {
      _currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ideaDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final ideaData = snapshot.data!['data'];
          _currentIdeaData = ideaData;
          
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(ideaData),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectTitle(ideaData),
                      SizedBox(height: 24.h),
                      _buildInfoSection('Project Abstract', ideaData['abstract']),
                      SizedBox(height: 24.h),
                      _buildInfoSection('Expected Investment', '\$${ideaData['expectedInvestment']}'),
                      SizedBox(height: 24.h),
                      _buildRatingSection(ideaData),
                      SizedBox(height: 24.h),
                      _buildContactSection(ideaData),
                      SizedBox(height: 32.h),
                      _buildActionButtons(ideaData),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300.h,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.w,
                          height: 24.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          height: 80.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> ideaData) {
    return SliverAppBar(
      expandedHeight: 300.h,
      floating: false,
      pinned: true,
      backgroundColor: AppArray().colors[0],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppArray().colors[0],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              CircleAvatar(
                radius: 60.r,
                backgroundColor: AppArray().colors[1],
                backgroundImage: NetworkImage(
                  ideaData['entrepreneur']['imageUrl'] ?? '',
                ),
                onBackgroundImageError: (_, __) => Icon(
                  Icons.person,
                  size: 60.r,
                  color: AppArray().colors[0],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                ideaData['entrepreneur']['name'] ?? '',
                style: TextStyle(
                  color: AppArray().colors[1],
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppArray().colors[1].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  ideaData['category']['name'] ?? '',
                  style: TextStyle(
                    color: AppArray().colors[1],
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppArray().colors[1]),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildProjectTitle(Map<String, dynamic> ideaData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Details',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppArray().colors[0],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          ideaData['title'] ?? '',
          style: TextStyle(
            fontSize: 18.sp,
            color: AppArray().colors[3],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppArray().colors[1],
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppArray().colors[0],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppArray().colors[3],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(Map<String, dynamic> ideaData) {
    final List<dynamic> ratings = ideaData['ratings'] ?? [];
    final double averageRating = ratings.isEmpty 
        ? 0.0 
        : ratings.map((r) => r['rating'] as int).reduce((a, b) => a + b) / ratings.length;

    final userRating = ratings.firstWhere(
      (rating) => rating['investor']['id'] == _currentUserId,
      orElse: () => null,
    );
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppArray().colors[1],
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _showRatingsBottomSheet(context, ratings),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ratings & Reviews',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppArray().colors[0],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${ratings.length} ${ratings.length == 1 ? 'review' : 'reviews'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppArray().colors[3],
                      ),
                    ),
                  ],
                ),
                if (ratings.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppArray().colors[0],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppArray().colors[1],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.star,
                          color: AppArray().colors[1],
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (ratings.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final rating = ratings[index];
                  final isUserRating = rating['investor']['id'] == _currentUserId;
                  return Container(
                    width: 280.w,
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isUserRating ? AppArray().colors[0].withOpacity(0.1) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                      border: isUserRating ? Border.all(color: AppArray().colors[0], width: 1) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundImage: NetworkImage(
                                rating['investor']['imageUrl'] ?? '',
                              ),
                              onBackgroundImageError: (_, __) => Icon(
                                Icons.person,
                                size: 16.r,
                                color: AppArray().colors[0],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              isUserRating ? 'You' : (rating['investor']['name'] ?? ''),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppArray().colors[0],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: List.generate(
                                5,
                                (starIndex) => Icon(
                                  starIndex < rating['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: AppArray().colors[0],
                                  size: 14.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (rating['comment']?.isNotEmpty ?? false) ...[
                          SizedBox(height: 8.h),
                          Expanded(
                            child: Text(
                              rating['comment'],
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppArray().colors[3],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 24.h),
          Text(
            userRating != null ? 'Edit Your Rating' : 'Add Your Rating',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppArray().colors[0],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentRating = index + 1;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    index < _currentRating ? Icons.star : Icons.star_border,
                    color: AppArray().colors[0],
                    size: 32.r,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your review (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => _submitRating(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppArray().colors[0],
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              userRating != null ? 'Update Rating' : 'Submit Rating',
              style: TextStyle(
                color: AppArray().colors[1],
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingsBottomSheet(BuildContext context, List<dynamic> ratings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: AppArray().colors[1],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                'All Reviews',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppArray().colors[0],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                itemCount: ratings.length,
                separatorBuilder: (context, index) => Divider(height: 24.h),
                itemBuilder: (context, index) {
                  final rating = ratings[index];
                  final isUserRating = rating['investor']['id'] == _currentUserId;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: NetworkImage(
                              rating['investor']['imageUrl'] ?? '',
                            ),
                            onBackgroundImageError: (_, __) => Icon(
                              Icons.person,
                              size: 20.r,
                              color: AppArray().colors[0],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUserRating ? 'You' : (rating['investor']['name'] ?? ''),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppArray().colors[0],
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    starIndex < rating['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: AppArray().colors[0],
                                    size: 16.r,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isUserRating)
                            Container(
                              margin: EdgeInsets.only(left: 8.w),
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppArray().colors[0],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Your Review',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppArray().colors[1],
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (rating['comment']?.isNotEmpty ?? false) ...[
                        SizedBox(height: 8.h),
                        Text(
                          rating['comment'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppArray().colors[3],
                          ),
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Text(
                        _formatDate(rating['createdAt']),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppArray().colors[3],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildContactSection(Map<String, dynamic> ideaData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppArray().colors[1],
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppArray().colors[0],
            ),
          ),
          SizedBox(height: 16.h),
          _buildContactItem(Icons.email, 'Email', ideaData['entrepreneur']['email'] ?? 'Not available'),
          SizedBox(height: 12.h),
          _buildContactItem(Icons.phone, 'Phone', 'Contact through app'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppArray().colors[0], size: 24.r),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppArray().colors[3],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppArray().colors[0],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> ideaData) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await NavigationHelper.navigateToPayment(
                context,
                amount: double.parse(ideaData['expectedInvestment'].toString()),
                userId: ideaData['entrepreneur']['id'],
                projectId: widget.ideaId,
              );
              
              if (result == true) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Investment successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {
                    _ideaDetailsFuture = _investorService.getIdeaDetails(widget.ideaId);
                  });
                }
              }
            },
            icon: Icon(Icons.payment, color: AppArray().colors[1]),
            label: Text(
              'Invest Now',
              style: TextStyle(
                color: AppArray().colors[1],
                fontSize: 16.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppArray().colors[0],
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                context.read<ChatBloc>().add(InitializeChat(_currentUserId!, widget.ideaId));
                final state = await context.read<ChatBloc>().stream.firstWhere(
                  (state) => state is ChatInitialized || state is ChatError,
                );
                
                if (state is ChatInitialized) {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(chat: state.chat),
                      ),
                    );
                  }
                } else if (state is ChatError) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to initialize chat: $e')),
                  );
                }
              }
            },
            icon: Icon(Icons.chat, color: AppArray().colors[1]),
            label: Text(
              'Chat with Owner',
              style: TextStyle(
                color: AppArray().colors[1],
                fontSize: 16.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppArray().colors[2],
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitRating() async {
    if (_currentRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    try {
      await _investorService.rateIdea(
        widget.ideaId,
        _currentRating,
        _commentController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating submitted successfully')),
      );

      // Refresh the idea details
      setState(() {
        _ideaDetailsFuture = _investorService.getIdeaDetails(widget.ideaId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit rating: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
} 