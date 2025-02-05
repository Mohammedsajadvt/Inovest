import 'dart:convert';

class Category {
    final String name;
    final String description;

    Category({
        required this.name,
        required this.description,
    });

    Category copyWith({
        String? name,
        String? description,
    }) => 
        Category(
            name: name ?? this.name,
            description: description ?? this.description,
        );

    factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
    };
}
