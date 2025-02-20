import 'dart:convert';

class InvestorCategories {
    bool success;
    List<Datum> data;

    InvestorCategories({
        required this.success,
        required this.data,
    });

    factory InvestorCategories.fromRawJson(String str) => InvestorCategories.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InvestorCategories.fromJson(Map<String, dynamic> json) => InvestorCategories(
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
    String name;
    String description;
    DateTime createdAt;
    Count count;

    Datum({
        required this.id,
        required this.name,
        required this.description,
        required this.createdAt,
        required this.count,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        count: Count.fromJson(json["_count"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "_count": count.toJson(),
    };
}

class Count {
    int projects;

    Count({
        required this.projects,
    });

    factory Count.fromRawJson(String str) => Count.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Count.fromJson(Map<String, dynamic> json) => Count(
        projects: json["projects"],
    );

    Map<String, dynamic> toJson() => {
        "projects": projects,
    };
}
