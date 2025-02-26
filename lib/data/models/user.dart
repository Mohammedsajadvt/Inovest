class User {
  final String id;
  final String name;
  final String? email;
  final String? imageUrl;
  final DateTime? lastSeen;

  User({
    required this.id,
    required this.name,
    this.email,
    this.imageUrl,
    this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      if (json['id'] == null) {
        throw ArgumentError('User id is missing');
      }
      if (json['name'] == null) {
        throw ArgumentError('User name is missing');
      }

      return User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        imageUrl: json['imageUrl'] as String?,
        lastSeen: json['lastSeen'] != null 
            ? DateTime.parse(json['lastSeen'] as String)
            : null,
      );
    } catch (e, stackTrace) {
      print('Error parsing User: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (lastSeen != null) 'lastSeen': lastSeen?.toIso8601String(),
    };
  }
} 