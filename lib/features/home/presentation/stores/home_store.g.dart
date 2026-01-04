// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$forYouMoviesAtom = Atom(
    name: '_HomeStore.forYouMovies',
    context: context,
  );

  @override
  ObservableList<MovieEntity> get forYouMovies {
    _$forYouMoviesAtom.reportRead();
    return super.forYouMovies;
  }

  @override
  set forYouMovies(ObservableList<MovieEntity> value) {
    _$forYouMoviesAtom.reportWrite(value, super.forYouMovies, () {
      super.forYouMovies = value;
    });
  }

  late final _$genresAtom = Atom(name: '_HomeStore.genres', context: context);

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
    name: '_HomeStore.moviesByCategory',
    context: context,
  );

  @override
  ObservableMap<int, ObservableList<MovieEntity>> get moviesByCategory {
    _$moviesByCategoryAtom.reportRead();
    return super.moviesByCategory;
  }

  @override
  set moviesByCategory(ObservableMap<int, ObservableList<MovieEntity>> value) {
    _$moviesByCategoryAtom.reportWrite(value, super.moviesByCategory, () {
      super.moviesByCategory = value;
    });
  }

  late final _$selectedCategoryIndexAtom = Atom(
    name: '_HomeStore.selectedCategoryIndex',
    context: context,
  );

  @override
  int get selectedCategoryIndex {
    _$selectedCategoryIndexAtom.reportRead();
    return super.selectedCategoryIndex;
  }

  @override
  set selectedCategoryIndex(int value) {
    _$selectedCategoryIndexAtom.reportWrite(
      value,
      super.selectedCategoryIndex,
      () {
        super.selectedCategoryIndex = value;
      },
    );
  }

  late final _$isLoadingAtom = Atom(
    name: '_HomeStore.isLoading',
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

  late final _$isCategoryMoviesLoadingAtom = Atom(
    name: '_HomeStore.isCategoryMoviesLoading',
    context: context,
  );

  @override
  bool get isCategoryMoviesLoading {
    _$isCategoryMoviesLoadingAtom.reportRead();
    return super.isCategoryMoviesLoading;
  }

  @override
  set isCategoryMoviesLoading(bool value) {
    _$isCategoryMoviesLoadingAtom.reportWrite(
      value,
      super.isCategoryMoviesLoading,
      () {
        super.isCategoryMoviesLoading = value;
      },
    );
  }

  late final _$isDataLoadedAtom = Atom(
    name: '_HomeStore.isDataLoaded',
    context: context,
  );

  @override
  bool get isDataLoaded {
    _$isDataLoadedAtom.reportRead();
    return super.isDataLoaded;
  }

  @override
  set isDataLoaded(bool value) {
    _$isDataLoadedAtom.reportWrite(value, super.isDataLoaded, () {
      super.isDataLoaded = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_HomeStore.errorMessage',
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

  late final _$fetchInitialDataAsyncAction = AsyncAction(
    '_HomeStore.fetchInitialData',
    context: context,
  );

  @override
  Future<void> fetchInitialData() {
    return _$fetchInitialDataAsyncAction.run(() => super.fetchInitialData());
  }

  late final _$_fetchAllCategoryMoviesAsyncAction = AsyncAction(
    '_HomeStore._fetchAllCategoryMovies',
    context: context,
  );

  @override
  Future<void> _fetchAllCategoryMovies() {
    return _$_fetchAllCategoryMoviesAsyncAction.run(
      () => super._fetchAllCategoryMovies(),
    );
  }

  late final _$_HomeStoreActionController = ActionController(
    name: '_HomeStore',
    context: context,
  );

  @override
  void setInitialData({
    required List<MovieEntity> popularMovies,
    required List<GenreEntity> genresList,
    required Map<int, List<MovieEntity>> categoryMovies,
  }) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.setInitialData',
    );
    try {
      return super.setInitialData(
        popularMovies: popularMovies,
        genresList: genresList,
        categoryMovies: categoryMovies,
      );
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedCategoryIndex(int index) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.setSelectedCategoryIndex',
    );
    try {
      return super.setSelectedCategoryIndex(index);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void personalizeForYou() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.personalizeForYou',
    );
    try {
      return super.personalizeForYou();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
forYouMovies: ${forYouMovies},
genres: ${genres},
moviesByCategory: ${moviesByCategory},
selectedCategoryIndex: ${selectedCategoryIndex},
isLoading: ${isLoading},
isCategoryMoviesLoading: ${isCategoryMoviesLoading},
isDataLoaded: ${isDataLoaded},
errorMessage: ${errorMessage}
    ''';
  }
}
