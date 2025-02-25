import 'dart:convert';

class TopIdeas {
  bool success;
  List<Datum>? data;

  TopIdeas({
    required this.success,
    this.data,
  });

  factory TopIdeas.fromRawJson(String str) => TopIdeas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TopIdeas.fromJson(Map<String, dynamic> json) {
    print("TopIdeas JSON: $json");
    return TopIdeas(
      success: json["success"] ?? false,
      data: json["data"] != null
          ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
  };
}

class Datum {
  String id;
  String entrepreneurId;
  String categoryId;
  String title;
  String datumAbstract;
  String expectedInvestment;
  Status? status;
  DateTime createdAt;
  DateTime updatedAt;
  Category? category;
  Entrepreneur? entrepreneur;
  Count? count;

  Datum({
    required this.id,
    required this.entrepreneurId,
    required this.categoryId,
    required this.title,
    required this.datumAbstract,
    required this.expectedInvestment,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.entrepreneur,
    this.count,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) {
    print("Datum JSON: $json");
    return Datum(
      id: json["id"] ?? "",
      entrepreneurId: json["entrepreneurId"] ?? "",
      categoryId: json["categoryId"] ?? "",
      title: json["title"] ?? "",
      datumAbstract: json["abstract"] ?? "",
      expectedInvestment: json["expectedInvestment"] ?? "",
      status: json["status"] != null ? statusValues.map[json["status"]] : null,
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
      updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.now(),
      category: json["category"] != null ? Category.fromJson(json["category"]) : null,
      entrepreneur: json["entrepreneur"] != null ? Entrepreneur.fromJson(json["entrepreneur"]) : null,
      count: json["_count"] != null ? Count.fromJson(json["_count"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "entrepreneurId": entrepreneurId,
    "categoryId": categoryId,
    "title": title,
    "abstract": datumAbstract,
    "expectedInvestment": expectedInvestment,
    "status": status != null ? statusValues.reverse[status] : null,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "category": category?.toJson(),
    "entrepreneur": entrepreneur?.toJson(),
    "_count": count?.toJson(),
  };
}

class Category {
  String id;
  String name;
  String description;
  DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
  };
}

class Count {
  int ratings;
  int interests;

  Count({
    required this.ratings,
    required this.interests,
  });

  factory Count.fromRawJson(String str) => Count.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    ratings: json["ratings"] ?? 0,
    interests: json["interests"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "ratings": ratings,
    "interests": interests,
  };
}

class Entrepreneur {
  String id;
  String name;
  String? imageUrl;

  Entrepreneur({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory Entrepreneur.fromRawJson(String str) => Entrepreneur.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Entrepreneur.fromJson(Map<String, dynamic> json) {
    print("Entrepreneur JSON: $json");
    return Entrepreneur(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "imageUrl": imageUrl,
  };
}





enum Status {
  AVAILABLE
}

final statusValues = EnumValues({
  "AVAILABLE": Status.AVAILABLE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}