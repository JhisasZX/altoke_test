import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

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
  final PostRepository repository;
  PostsCubit(this.repository) : super(const PostsState());

  Future<void> fetchPosts() async {
    emit(state.copyWith(status: PostsStatus.loading));
    try {
      final posts = await repository.getPosts();
      emit(state.copyWith(status: PostsStatus.loaded, posts: posts));
    } catch (e) {
      emit(state.copyWith(status: PostsStatus.error, message: e.toString()));
    }
  }

  Future<void> addPost(
      {required String title,
      required String body,
      required int userId}) async {
    try {
      final newPost = Post(id: 0, userId: userId, title: title, body: body);
      final created = await repository.addPost(newPost);
      // El post se agrega como primer elemento de la lista
      final updated = [created, ...state.posts];
      emit(state.copyWith(status: PostsStatus.loaded, posts: updated));
    } catch (e) {
      emit(state.copyWith(status: PostsStatus.error, message: e.toString()));
    }
  }
}
