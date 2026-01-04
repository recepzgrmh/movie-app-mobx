// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SplashStore on _SplashStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_SplashStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isInitializedAtom = Atom(
    name: '_SplashStore.isInitialized',
    context: context,
  );

  @override
  bool get isInitialized {
    _$isInitializedAtom.reportRead();
    return super.isInitialized;
  }

  @override
  set isInitialized(bool value) {
    _$isInitializedAtom.reportWrite(value, super.isInitialized, () {
      super.isInitialized = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_SplashStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$popularMoviesAtom = Atom(
    name: '_SplashStore.popularMovies',
    context: context,
  );

  @override
  ObservableList<MovieEntity> get popularMovies {
    _$popularMoviesAtom.reportRead();
    return super.popularMovies;
  }

  @override
  set popularMovies(ObservableList<MovieEntity> value) {
    _$popularMoviesAtom.reportWrite(value, super.popularMovies, () {
      super.popularMovies = value;
    });
  }

  late final _$genresAtom = Atom(name: '_SplashStore.genres', context: context);

  @override
  ObservableList<GenreEntity> get genres {
    _$genresAtom.reportRead();
    return super.genres;
  }

  @override
  set genres(ObservableList<GenreEntity> value) {
    _$genresAtom.reportWrite(value, super.genres, () {
      super.genres = value;
    });
  }

  late final _$moviesByCategoryAtom = Atom(
    name: '_SplashStore.moviesByCategory',
    context: context,
  );

  @override
  ObservableMap<int, List<MovieEntity>> get moviesByCategory {
    _$moviesByCategoryAtom.reportRead();
    return super.moviesByCategory;
  }

  @override
  set moviesByCategory(ObservableMap<int, List<MovieEntity>> value) {
    _$moviesByCategoryAtom.reportWrite(value, super.moviesByCategory, () {
      super.moviesByCategory = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    '_SplashStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$_fetchAllCategoryMoviesAsyncAction = AsyncAction(
    '_SplashStore._fetchAllCategoryMovies',
    context: context,
  );

  @override
  Future<void> _fetchAllCategoryMovies() {
    return _$_fetchAllCategoryMoviesAsyncAction.run(
      () => super._fetchAllCategoryMovies(),
    );
  }

  late final _$_SplashStoreActionController = ActionController(
    name: '_SplashStore',
    context: context,
  );

  @override
  void _assignGenreImages() {
    final _$actionInfo = _$_SplashStoreActionController.startAction(
      name: '_SplashStore._assignGenreImages',
    );
    try {
      return super._assignGenreImages();
    } finally {
      _$_SplashStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isInitialized: ${isInitialized},
errorMessage: ${errorMessage},
popularMovies: ${popularMovies},
genres: ${genres},
moviesByCategory: ${moviesByCategory}
    ''';
  }
}
