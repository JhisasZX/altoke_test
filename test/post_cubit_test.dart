import 'package:flutter_test/flutter_test.dart';
import 'package:altoke_test/src/presentation/cubit/posts_cubit.dart';
import 'package:altoke_test/src/domain/entities/post.dart';
import 'package:altoke_test/src/domain/entities/comment.dart';
import 'package:altoke_test/src/domain/repositories/post_repository.dart';
import 'package:altoke_test/src/domain/usecases/get_posts_usecase.dart';
import 'package:altoke_test/src/domain/usecases/add_post_usecase.dart';

class FakePostRepository implements PostRepository {
  @override
  Future<Post> addPost(Post post) async => post;

  @override
  Future<List<Post>> getPosts() async => [
        const Post(id: 1, userId: 1, title: 'Test Post', body: 'Test Body'),
      ];

  @override
  Future<List<Comment>> getComments(int postId) async => [
        Comment(
          id: 1,
          postId: postId,
          name: 'Test User',
          email: 'test@example.com',
          body: 'Test Comment',
        ),
      ];
}

void main() {
  group('PostsCubit Tests', () {
    late FakePostRepository fakeRepository;
    late GetPostsUseCase getPostsUseCase;
    late AddPostUseCase addPostUseCase;
    late PostsCubit postsCubit;

    setUp(() {
      fakeRepository = FakePostRepository();
      getPostsUseCase = GetPostsUseCase(fakeRepository);
      addPostUseCase = AddPostUseCase(fakeRepository);
      postsCubit = PostsCubit(
        getPostsUseCase: getPostsUseCase,
        addPostUseCase: addPostUseCase,
      );
    });

    tearDown(() {
      postsCubit.close();
    });

    test('Estado inicial debe ser correcto', () {
      expect(postsCubit.state.status, PostsStatus.initial);
      expect(postsCubit.state.posts, isEmpty);
      expect(postsCubit.state.message, isNull);
    });

    test('fetchPosts debe cargar posts correctamente', () async {
      // Act
      await postsCubit.fetchPosts();

      // Assert
      expect(postsCubit.state.status, PostsStatus.loaded);
      expect(postsCubit.state.posts.length, 1);
      expect(postsCubit.state.posts.first.title, 'Test Post');
      expect(postsCubit.state.posts.first.body, 'Test Body');
    });

    test('addPost debe agregar un nuevo post', () async {
      // Arrange
      await postsCubit.fetchPosts(); // Cargar posts iniciales
      final initialCount = postsCubit.state.posts.length;

      // Act
      await postsCubit.addPost(
        title: 'Nuevo Post',
        body: 'Contenido del nuevo post',
        userId: 2,
      );

      // Assert
      expect(postsCubit.state.status, PostsStatus.loaded);
      expect(postsCubit.state.posts.length, initialCount + 1);
      expect(postsCubit.state.posts.first.title, 'Nuevo Post');
      expect(postsCubit.state.posts.first.userId, 2);
    });
  });
}
