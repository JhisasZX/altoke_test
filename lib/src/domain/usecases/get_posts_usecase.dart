import '../entities/post.dart';
import '../repositories/post_repository.dart';
import '../../core/errors/app_errors.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<Post>> call() async {
    try {
      return await repository.getPosts();
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      throw const NetworkError('Error al obtener los posts');
    }
  }
}
