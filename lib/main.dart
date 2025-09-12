import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/core/network/api_client.dart';
import 'src/data/datasources/post_remote_datasource.dart';
import 'src/data/repositories/post_repository_impl.dart';
import 'src/domain/repositories/post_repository.dart';
import 'src/presentation/cubit/posts_cubit.dart';
import 'src/presentation/pages/splash_page.dart';
import 'src/presentation/pages/welcome_page.dart';
import 'src/presentation/pages/posts_list_page.dart';

void main() {
  final apiClient = ApiClient();
  final dataSource = PostRemoteDatasourceImpl(client: apiClient.dio);
  final repo = PostRepositoryImpl(remote: dataSource);

  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final PostRepositoryImpl repository;
  const MyApp({super.key, required this.repository}) : super();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PostRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => PostsCubit(repository),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Post-it',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: Colors.blue,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              focusColor: Colors.blue,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.blue,
              selectionColor: Colors.blue,
              selectionHandleColor: Colors.blue,
            ),
          ),
          home: const SplashPage(),
          routes: {
            '/welcome': (_) => const WelcomePage(),
            '/posts': (_) => const PostsListPage(),
          },
        ),
      ),
    );
  }
}
