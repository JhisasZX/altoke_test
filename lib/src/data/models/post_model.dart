import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: _safeParseInt(json['id']),
      userId: _safeParseInt(json['userId']),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  // Método auxiliar para parsear enteros de forma segura
  static int _safeParseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        throw FormatException('No se puede convertir "$value" a entero: $e');
      }
    }

    // Si es otro tipo, intentar convertirlo a string y luego a int
    try {
      return int.parse('$value');
    } catch (e) {
      throw FormatException('No se puede convertir "$value" a entero: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      };
}
