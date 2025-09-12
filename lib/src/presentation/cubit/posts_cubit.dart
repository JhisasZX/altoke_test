import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/add_post_usecase.dart';
import '../../core/errors/app_errors.dart';

enum PostsStatus { initial, loading, loaded, error }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<Post> posts;
  final String? message;

  const PostsState(
      {this.status = PostsStatus.initial, this.posts = const [], this.message});

  PostsState copyWith(
      {PostsStatus? status, List<Post>? posts, String? message}) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, posts, message];
}

class PostsCubit extends Cubit<PostsState> {
  final GetPostsUseCase getPostsUseCase;
  final AddPostUseCase addPostUseCase;

  PostsCubit({
    required this.getPostsUseCase,
    required this.addPostUseCase,
  }) : super(const PostsState());

  Future<void> fetchPosts() async {
    emit(state.copyWith(status: PostsStatus.loading));
    try {
      final posts = await getPostsUseCase.call();
      emit(state.copyWith(status: PostsStatus.loaded, posts: posts));
    } on AppError catch (e) {
      emit(state.copyWith(status: PostsStatus.error, message: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: PostsStatus.error, message: 'Error inesperado: $e'));
    }
  }

  Future<void> addPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final created = await addPostUseCase.call(
        title: title,
        body: body,
        userId: userId,
      );
      // El post se agrega como primer elemento de la lista
      final updated = [created, ...state.posts];
      emit(state.copyWith(status: PostsStatus.loaded, posts: updated));
    } on AppError catch (e) {
      emit(state.copyWith(status: PostsStatus.error, message: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: PostsStatus.error, message: 'Error inesperado: $e'));
    }
  }
}
