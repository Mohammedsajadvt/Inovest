import 'dart:convert';

class CategoryModel {
    final String name;
    final String description;

    CategoryModel({
        required this.name,
        required this.description,
    });

    CategoryModel copyWith({
        String? name,
        String? description,
    }) => 
        CategoryModel(
            name: name ?? this.name,
            description: description ?? this.description,
        );

    factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
    };
}
