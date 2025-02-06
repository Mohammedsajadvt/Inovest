class IdeasModel {
  final String? title;
  final String? abstract;
  final double? expectedInvestment;
  final String? categoryId;

 IdeasModel({
    this.title,
    this.abstract,
    this.expectedInvestment,
    this.categoryId,
  });

  factory IdeasModel.fromJson(Map<String, dynamic> json) {
    return IdeasModel(
      title: json['title'],
      abstract: json['abstract'],
      expectedInvestment: json['expectedInvestment']?.toDouble(),
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'abstract': abstract,
      'expectedInvestment': expectedInvestment,
      'categoryId': categoryId,
    };
  }
}
