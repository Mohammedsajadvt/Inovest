import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/data/services/investor_service.dart';
import 'package:shimmer/shimmer.dart';

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

  @override
  void initState() {
    super.initState();
    _ideaDetailsFuture = _investorService.getIdeaDetails(widget.ideaId);
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
                      _buildActionButtons(),
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
            'Rate this Project',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppArray().colors[0],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _currentRating = index + 1;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    index < _currentRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement contact functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppArray().colors[0],
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Contact Now',
              style: TextStyle(
                color: AppArray().colors[1],
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Container(
          decoration: BoxDecoration(
            color: AppArray().colors[1],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppArray().colors[0]),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              // TODO: Implement favorite functionality
            },
            icon: Icon(
              Icons.favorite_border,
              color: AppArray().colors[0],
              size: 24.r,
            ),
          ),
        ),
      ],
    );
  }
} 