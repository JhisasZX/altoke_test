import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.name,
    required super.email,
    required super.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.parse('${json['id']}'),
      postId: json['postId'] is int
          ? json['postId']
          : int.parse('${json['postId']}'),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'name': name,
        'email': email,
        'body': body,
      };
}
