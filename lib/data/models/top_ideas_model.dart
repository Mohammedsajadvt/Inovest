import 'dart:convert';

class TopIdeas {
    bool success;
    List<Datum> data;

    TopIdeas({
        required this.success,
        required this.data,
    });

    factory TopIdeas.fromRawJson(String str) => TopIdeas.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TopIdeas.fromJson(Map<String, dynamic> json) => TopIdeas(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String entrepreneurId;
    String categoryId;
    String title;
    String datumAbstract;
    String expectedInvestment;
    Status status;
    DateTime createdAt;
    DateTime updatedAt;
    Category category;
    Entrepreneur entrepreneur;
    Count count;

    Datum({
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
        required this.count,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        entrepreneurId: json["entrepreneurId"],
        categoryId: json["categoryId"],
        title: json["title"],
        datumAbstract: json["abstract"],
        expectedInvestment: json["expectedInvestment"],
        status: statusValues.map[json["status"]]!,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        category: Category.fromJson(json["category"]),
        entrepreneur: Entrepreneur.fromJson(json["entrepreneur"]),
        count: Count.fromJson(json["_count"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "entrepreneurId": entrepreneurId,
        "categoryId": categoryId,
        "title": title,
        "abstract": datumAbstract,
        "expectedInvestment": expectedInvestment,
        "status": statusValues.reverse[status],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "category": category.toJson(),
        "entrepreneur": entrepreneur.toJson(),
        "_count": count.toJson(),
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
        ratings: json["ratings"],
        interests: json["interests"],
    );

    Map<String, dynamic> toJson() => {
        "ratings": ratings,
        "interests": interests,
    };
}

class Entrepreneur {
    String id;
    Name name;
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
        name: nameValues.map[json["name"]]!,
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "imageUrl": imageUrl,
    };
}

enum Name {
    HISHAM,
    TEST,
    UNNI
}

final nameValues = EnumValues({
    "hisham": Name.HISHAM,
    "test": Name.TEST,
    "unni": Name.UNNI
});

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
