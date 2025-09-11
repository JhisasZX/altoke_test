import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

/// Abstract class defining the contract for remote data operations
/// related to posts and comments from JSONPlaceholder API
abstract class PostRemoteDataSource {
  /// Fetches all posts from the remote API
  ///
  /// Returns a [List<PostModel>] containing all available posts
  /// Throws [Exception] if the request fails
  Future<List<PostModel>> fetchPosts();

  /// Creates a new post in the remote API
  ///
  /// [post] - The post model to create
  /// Returns a [PostModel] with the created post data
  /// Throws [Exception] if the request fails
  Future<PostModel> createPost(PostModel post);

  /// Fetches all comments for a specific post
  ///
  /// [postId] - The ID of the post to fetch comments for
  /// Returns a [List<CommentModel>] containing all comments for the post
  /// Throws [ArgumentError] if postId is invalid
  /// Throws [Exception] if the request fails
  Future<List<CommentModel>> fetchComments(int postId);
}

/// Implementation of [PostRemoteDataSource] using Dio HTTP client
///
/// This class handles all remote data operations for posts and comments
/// by making HTTP requests to the JSONPlaceholder API
class PostRemoteDatasourceImpl implements PostRemoteDataSource {
  /// Dio HTTP client instance for making API requests
  final Dio client;

  /// Creates a new instance of [PostRemoteDatasourceImpl]
  ///
  /// [client] - The Dio HTTP client to use for API requests
  PostRemoteDatasourceImpl({required this.client});

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final resp = await client.get('/posts');
      final list = (resp.data as List)
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      throw Exception('Error fetching posts: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final resp = await client.post('/posts', data: post.toJson());
      return PostModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error creating post: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<CommentModel>> fetchComments(int postId) async {
    // Validación de parámetros
    if (postId <= 0) {
      throw ArgumentError('Post ID must be greater than 0, received: $postId');
    }

    try {
      final resp = await client.get('/posts/$postId/comments');
      final list = (resp.data as List)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      throw Exception('Error fetching comments for post $postId: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
