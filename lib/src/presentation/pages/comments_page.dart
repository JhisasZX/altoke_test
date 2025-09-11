import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/comments_cubit.dart';
import '../../domain/repositories/post_repository.dart';

class CommentsPage extends StatelessWidget {
  final int postId;
  final String postTitle;
  final PostRepository repository;
  const CommentsPage(
      {super.key,
      required this.postId,
      required this.postTitle,
      required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentsCubit(repository)..fetchComments(postId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Comentarios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: BlocBuilder<CommentsCubit, CommentsState>(
          builder: (context, state) {
            if (state.status == CommentsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == CommentsStatus.error) {
              return Center(child: Text(state.message ?? 'Error'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.comments.length,
              itemBuilder: (context, i) {
                final c = state.comments[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          c.body,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
