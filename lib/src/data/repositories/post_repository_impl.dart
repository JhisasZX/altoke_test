import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  PostRepositoryImpl({required this.remote});

  @override
  Future<List<Post>> getPosts() async {
    return remote.fetchPosts();
  }

  @override
  Future<Post> addPost(Post post) async {
    final model = PostModel(
        id: post.id, userId: post.userId, title: post.title, body: post.body);
    return remote.createPost(model);
  }

  @override
  Future<List<Comment>> getComments(int postId) async {
    return remote.fetchComments(postId);
  }
}
