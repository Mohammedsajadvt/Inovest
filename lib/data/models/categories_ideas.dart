import 'dart:convert';

class CategoriesIdeasModel {
    bool success;
    List<DatumIdeas> data;

    CategoriesIdeasModel({
        required this.success,
        required this.data,
    });

    factory CategoriesIdeasModel.fromRawJson(String str) => CategoriesIdeasModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoriesIdeasModel.fromJson(Map<String, dynamic> json) => CategoriesIdeasModel(
        success: json["success"],
        data: List<DatumIdeas>.from(json["data"].map((x) => DatumIdeas.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumIdeas {
    String id;
    String entrepreneurId;
    String categoryId;
    String title;
    String datumAbstract;
    String expectedInvestment;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    Category category;
    Entrepreneur entrepreneur;

   DatumIdeas({
        required this.id,
        required this.entrepreneurId,
        required this.categoryId,
        required this.title,
        required this.datumAbstract,
        required this.expectedInvestment,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.category,
        required this.entrepreneur,
    });

    factory DatumIdeas.fromRawJson(String str) => DatumIdeas.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumIdeas.fromJson(Map<String, dynamic> json) => DatumIdeas(
        id: json["id"],
        entrepreneurId: json["entrepreneurId"],
        categoryId: json["categoryId"],
        title: json["title"],
        datumAbstract: json["abstract"],
        expectedInvestment: json["expectedInvestment"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        category: Category.fromJson(json["category"]),
        entrepreneur: Entrepreneur.fromJson(json["entrepreneur"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "entrepreneurId": entrepreneurId,
        "categoryId": categoryId,
        "title": title,
        "abstract": datumAbstract,
        "expectedInvestment": expectedInvestment,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "category": category.toJson(),
        "entrepreneur": entrepreneur.toJson(),
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
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
    };
}

class Entrepreneur {
    String id;
    String name;
    String? imageUrl;

    Entrepreneur({
        required this.id,
        required this.name,
        required this.imageUrl,
    });

    factory Entrepreneur.fromRawJson(String str) => Entrepreneur.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Entrepreneur.fromJson(Map<String, dynamic> json) => Entrepreneur(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
    };
}
