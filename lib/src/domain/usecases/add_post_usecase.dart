import '../entities/post.dart';
import '../repositories/post_repository.dart';
import '../../core/errors/app_errors.dart';

class AddPostUseCase {
  final PostRepository repository;

  AddPostUseCase(this.repository);

  Future<Post> call({
    required String title,
    required String body,
    required int userId,
  }) async {
    // Validación de entrada
    if (title.trim().isEmpty) {
      throw const ValidationError('El título no puede estar vacío');
    }

    if (body.trim().isEmpty) {
      throw const ValidationError('El contenido no puede estar vacío');
    }

    if (userId <= 0) {
      throw const ValidationError('El ID de usuario debe ser mayor a 0');
    }

    try {
      final newPost = Post(
        id: 0, // Se asignará en el servidor
        userId: userId,
        title: title.trim(),
        body: body.trim(),
      );

      return await repository.addPost(newPost);
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      throw const NetworkError('Error al crear el post');
    }
  }
}
