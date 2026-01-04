// lib/features/onboarding/presentation/stores/onboarding_store.dart
import 'package:mobx/mobx.dart';
import 'package:movie_app/core/services/local_storage_service.dart';
import 'package:movie_app/features/home/domain/entities/genre_entity.dart';
import 'package:movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:movie_app/features/home/domain/usecases/get_popular_movies_usecase.dart';

part 'onboarding_store.g.dart';

enum OnboardingStep { movies, genres, paywall }

class OnboardingStore = _OnboardingStore with _$OnboardingStore;

abstract class _OnboardingStore with Store {
  final GetPopularMoviesUseCase getPopularMoviesUseCase;
  final LocalStorageService localStorageService;

  _OnboardingStore({
    required this.getPopularMoviesUseCase,
    required this.localStorageService,
  });

  static const int maxMoviesAllowed = 3;
  static const int maxGenresAllowed = 2;

  // ─────────────────────────────────────────────────────────────────────────────
  // Available Data (loaded from API)
  // ─────────────────────────────────────────────────────────────────────────────
  @observable
  ObservableList<MovieEntity> availableMovies = ObservableList<MovieEntity>();

  @observable
  ObservableList<GenreEntity> availableGenres = ObservableList<GenreEntity>();

  // ─────────────────────────────────────────────────────────────────────────────
  // Selected Data
  // ─────────────────────────────────────────────────────────────────────────────
  @observable
  ObservableList<MovieEntity> selectedMovies = ObservableList<MovieEntity>();

  @observable
  ObservableList<GenreEntity> selectedGenres = ObservableList<GenreEntity>();

  // ─────────────────────────────────────────────────────────────────────────────
  // Loading & Pagination State
  // ─────────────────────────────────────────────────────────────────────────────
  @observable
  int currentPage = 1;

  @observable
  bool isLoadingMore = false;

  @observable
  bool hasMorePages = true;

  @observable
  OnboardingStep step = OnboardingStep.movies;

  // ─────────────────────────────────────────────────────────────────────────────
  // Initialize with data from Splash
  // ─────────────────────────────────────────────────────────────────────────────
  @action
  void initWithData(List<MovieEntity> movies, List<GenreEntity> genres) {
    availableMovies.clear();
    availableGenres.clear();
    availableMovies.addAll(movies);
    availableGenres.addAll(genres);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────────────────
  @action
  void toggleMovieSelection(MovieEntity movie) {
    final index = selectedMovies.indexWhere((m) => m.id == movie.id);
    if (index >= 0) {
      // Already selected - remove it
      selectedMovies.removeAt(index);
    } else {
      // Not selected - add only if under max limit
      if (selectedMovies.length < maxMoviesAllowed) {
        selectedMovies.add(movie);
      }
    }
  }

  @action
  void toggleGenreSelection(GenreEntity genre) {
    final index = selectedGenres.indexWhere((g) => g.id == genre.id);
    if (index >= 0) {
      // Already selected - remove it
      selectedGenres.removeAt(index);
    } else {
      // Not selected - add only if under max limit
      if (selectedGenres.length < maxGenresAllowed) {
        selectedGenres.add(genre);
      }
    }
  }

  @action
  Future<void> loadMoreMovies() async {
    if (isLoadingMore || !hasMorePages) return;

    isLoadingMore = true;
    try {
      final nextPage = currentPage + 1;
      final result = await getPopularMoviesUseCase(page: nextPage);

      result.when(
        success: (movies) {
          if (movies.isEmpty) {
            hasMorePages = false;
          } else {
            availableMovies.addAll(movies);
            currentPage = nextPage;
          }
        },
        error: (failure) {
          // Handle error silently or show snackbar
          hasMorePages = false;
        },
      );
    } finally {
      isLoadingMore = false;
    }
  }

  @computed
  bool get canContinue {
    switch (step) {
      case OnboardingStep.movies:
        return selectedMovies.length >= maxMoviesAllowed;
      case OnboardingStep.genres:
        return selectedGenres.length >= maxGenresAllowed;
      case OnboardingStep.paywall:
        return true;
    }
  }

  @action
  void setStep(OnboardingStep value) => step = value;

  // Helper to check if a movie is selected
  bool isMovieSelected(MovieEntity movie) {
    return selectedMovies.any((m) => m.id == movie.id);
  }

  // Helper to check if a genre is selected
  bool isGenreSelected(GenreEntity genre) {
    return selectedGenres.any((g) => g.id == genre.id);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Persistence
  // ─────────────────────────────────────────────────────────────────────────────
  
  /// Save current selections to local storage for personalization
  @action
  Future<void> saveSelectionsToStorage() async {
    final movieIds = selectedMovies.map((m) => m.id).toList();
    final genreIds = selectedGenres.map((g) => g.id).toList();
    
    await localStorageService.saveSelectedMovieIds(movieIds);
    await localStorageService.saveSelectedGenreIds(genreIds);
    await localStorageService.setOnboardingCompleted(true);
  }

  /// Load saved selections from local storage
  @action
  void loadSelectionsFromStorage(List<MovieEntity> allMovies, List<GenreEntity> allGenres) {
    final savedMovieIds = localStorageService.getSelectedMovieIds();
    final savedGenreIds = localStorageService.getSelectedGenreIds();
    
    if (savedMovieIds.isNotEmpty) {
      final movies = allMovies.where((m) => savedMovieIds.contains(m.id));
      selectedMovies.addAll(movies);
    }
    
    if (savedGenreIds.isNotEmpty) {
      final genres = allGenres.where((g) => savedGenreIds.contains(g.id));
      selectedGenres.addAll(genres);
    }
  }
}

