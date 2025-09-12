import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/core/network/api_client.dart';
import 'src/core/themes/app_theme.dart';
import 'src/core/constants/app_constants.dart';
import 'src/data/datasources/post_remote_datasource.dart';
import 'src/data/repositories/post_repository_impl.dart';
import 'src/domain/repositories/post_repository.dart';
import 'src/domain/usecases/get_posts_usecase.dart';
import 'src/domain/usecases/add_post_usecase.dart';
import 'src/domain/usecases/get_comments_usecase.dart';
import 'src/presentation/cubit/posts_cubit.dart';
import 'src/presentation/cubit/theme_cubit.dart';
import 'src/presentation/pages/splash_page.dart';
import 'src/presentation/pages/welcome_page.dart';
import 'src/presentation/pages/posts_list_page.dart';

void main() {
  // Configuración de dependencias
  final apiClient = ApiClient();
  final dataSource = PostRemoteDatasourceImpl(client: apiClient.dio);
  final repository = PostRepositoryImpl(remote: dataSource);

  // Casos de uso
  final getPostsUseCase = GetPostsUseCase(repository);
  final addPostUseCase = AddPostUseCase(repository);
  final getCommentsUseCase = GetCommentsUseCase(repository);

  runApp(MyApp(
    repository: repository,
    getPostsUseCase: getPostsUseCase,
    addPostUseCase: addPostUseCase,
    getCommentsUseCase: getCommentsUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final PostRepository repository;
  final GetPostsUseCase getPostsUseCase;
  final AddPostUseCase addPostUseCase;
  final GetCommentsUseCase getCommentsUseCase;

  const MyApp({
    super.key,
    required this.repository,
    required this.getPostsUseCase,
    required this.addPostUseCase,
    required this.getCommentsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PostRepository>.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => PostsCubit(
                    getPostsUseCase: getPostsUseCase,
                    addPostUseCase: addPostUseCase,
                  )),
          BlocProvider(create: (_) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const SplashPage(),
              routes: {
                '/welcome': (_) => const WelcomePage(),
                '/posts': (_) => const PostsListPage(),
              },
            );
          },
        ),
      ),
    );
  }
}
