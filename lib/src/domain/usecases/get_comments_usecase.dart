import '../entities/comment.dart';
import '../repositories/post_repository.dart';
import '../../core/errors/app_errors.dart';

class GetCommentsUseCase {
  final PostRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<Comment>> call(int postId) async {
    // Validación de entrada
    if (postId <= 0) {
      throw const ValidationError('El ID del post debe ser mayor a 0');
    }

    try {
      return await repository.getComments(postId);
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      throw const NetworkError('Error al obtener los comentarios');
    }
  }
}
