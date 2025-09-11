import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/post_repository.dart';

enum CommentsStatus { initial, loading, loaded, error }

class CommentsState extends Equatable {
  final CommentsStatus status;
  final List<Comment> comments;
  final String? message;

  const CommentsState(
      {this.status = CommentsStatus.initial,
      this.comments = const [],
      this.message});

  CommentsState copyWith(
      {CommentsStatus? status, List<Comment>? comments, String? message}) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, comments, message];
}

class CommentsCubit extends Cubit<CommentsState> {
  final PostRepository repository;
  CommentsCubit(this.repository) : super(const CommentsState());

  Future<void> fetchComments(int postId) async {
    emit(state.copyWith(status: CommentsStatus.loading));
    try {
      final comments = await repository.getComments(postId);
      emit(state.copyWith(status: CommentsStatus.loaded, comments: comments));
    } catch (e) {
      emit(state.copyWith(status: CommentsStatus.error, message: e.toString()));
    }
  }
}
