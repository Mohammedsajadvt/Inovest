import 'package:inovest/data/models/categories_ideas.dart';

class EntrepreneurIdeasModel {
  final bool success;
  final List<EntrepreneurIdea> data;

  EntrepreneurIdeasModel({
    required this.success,
    required this.data,
  });

  factory EntrepreneurIdeasModel.fromJson(Map<String, dynamic> json) {
    return EntrepreneurIdeasModel(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((idea) => EntrepreneurIdea.fromJson(idea))
          .toList(),
    );
  }
}

class EntrepreneurIdea {
  final String id;
  final String entrepreneurId;
  final String categoryId;
  final String title;
  final String abstract;
  final double expectedInvestment;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;
  final IdeaCounts counts;

  EntrepreneurIdea({
    required this.id,
    required this.entrepreneurId,
    required this.categoryId,
    required this.title,
    required this.abstract,
    required this.expectedInvestment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.counts,
  });

  factory EntrepreneurIdea.fromJson(Map<String, dynamic> json) {
    return EntrepreneurIdea(
      id: json['id'] ?? '',
      entrepreneurId: json['entrepreneurId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
      expectedInvestment: double.parse(json['expectedInvestment'].toString()),
      status: json['status'] ?? 'AVAILABLE',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: Category.fromJson(json['category']),
      counts: IdeaCounts.fromJson(json['_count']),
    );
  }
}

class IdeaCounts {
  final int ratings;
  final int interests;

  IdeaCounts({
    required this.ratings,
    required this.interests,
  });

  factory IdeaCounts.fromJson(Map<String, dynamic> json) {
    return IdeaCounts(
      ratings: json['ratings'] ?? 0,
      interests: json['interests'] ?? 0,
    );
  }
} 