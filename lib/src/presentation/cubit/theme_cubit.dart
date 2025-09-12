import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark }

class ThemeState extends Equatable {
  final AppThemeMode themeMode;
  final bool isDarkMode;

  const ThemeState({
    this.themeMode = AppThemeMode.light,
    this.isDarkMode = false,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [themeMode, isDarkMode];
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    if (state.isDarkMode) {
      emit(state.copyWith(themeMode: AppThemeMode.light, isDarkMode: false));
    } else {
      emit(state.copyWith(themeMode: AppThemeMode.dark, isDarkMode: true));
    }
  }

  void setTheme(AppThemeMode mode) {
    emit(state.copyWith(
      themeMode: mode,
      isDarkMode: mode == AppThemeMode.dark,
    ));
  }
}
