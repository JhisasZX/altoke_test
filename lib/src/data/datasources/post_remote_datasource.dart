import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../../core/errors/app_errors.dart';

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
      switch (e.response?.statusCode) {
        case 403:
          throw const ServerError(
              'Acceso denegado. La API está bloqueando la petición.',
              statusCode: 403);
        case 404:
          throw const PostError('No se encontraron posts.',
              code: 'POSTS_NOT_FOUND');
        case 500:
          throw const ServerError(
              'Error interno del servidor. Intenta más tarde.',
              statusCode: 500);
        default:
          throw NetworkError('Error de red: ${e.message}');
      }
    } catch (e) {
      if (e is AppError) rethrow;
      throw UnknownError('Error inesperado: $e');
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final resp = await client.post('/posts', data: post.toJson());
      return PostModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 403:
          throw const ServerError(
              'Acceso denegado. La API está bloqueando la petición.',
              statusCode: 403);
        case 400:
          throw const ValidationError('Datos inválidos para crear el post.',
              code: 'INVALID_POST_DATA');
        case 500:
          throw const ServerError(
              'Error interno del servidor. Intenta más tarde.',
              statusCode: 500);
        default:
          throw NetworkError('Error de red: ${e.message}');
      }
    } catch (e) {
      if (e is AppError) rethrow;
      throw UnknownError('Error inesperado: $e');
    }
  }

  @override
  Future<List<CommentModel>> fetchComments(int postId) async {
    // Validación de parámetros
    if (postId <= 0) {
      throw const ValidationError('El ID del post debe ser mayor a 0',
          code: 'INVALID_POST_ID');
    }

    try {
      final resp = await client.get('/posts/$postId/comments');
      final list = (resp.data as List)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 403:
          throw const ServerError(
              'Acceso denegado. La API está bloqueando la petición.',
              statusCode: 403);
        case 404:
          throw CommentError(
              'No se encontraron comentarios para el post $postId.',
              code: 'COMMENTS_NOT_FOUND');
        case 500:
          throw const ServerError(
              'Error interno del servidor. Intenta más tarde.',
              statusCode: 500);
        default:
          throw NetworkError('Error de red: ${e.message}');
      }
    } catch (e) {
      if (e is AppError) rethrow;
      throw UnknownError('Error inesperado: $e');
    }
  }
}
