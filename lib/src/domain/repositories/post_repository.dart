import '../entities/post.dart';
import '../entities/comment.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> addPost(Post post);
  Future<List<Comment>> getComments(int postId);
}
