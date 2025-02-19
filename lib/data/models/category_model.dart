import 'dart:convert';

class CategoryModel {
    final String id;
    final String name;
    final String description;

    CategoryModel({
        required this.id,
        required this.name,
        required this.description,
    });

    CategoryModel copyWith({
        String? id, 
        String? name,
        String? description,
    }) => 
        CategoryModel(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
        );

    factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id":id,
        "name": name,
        "description": description,
    };
}
