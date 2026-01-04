// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingStore on _OnboardingStore, Store {
  Computed<bool>? _$canContinueComputed;

  @override
  bool get canContinue => (_$canContinueComputed ??= Computed<bool>(
    () => super.canContinue,
    name: '_OnboardingStore.canContinue',
  )).value;

  late final _$availableMoviesAtom = Atom(
    name: '_OnboardingStore.availableMovies',
    context: context,
  );

  @override
  ObservableList<MovieEntity> get availableMovies {
    _$availableMoviesAtom.reportRead();
    return super.availableMovies;
  }

  @override
  set availableMovies(ObservableList<MovieEntity> value) {
    _$availableMoviesAtom.reportWrite(value, super.availableMovies, () {
      super.availableMovies = value;
    });
  }

  late final _$availableGenresAtom = Atom(
    name: '_OnboardingStore.availableGenres',
    context: context,
  );

  @override
  ObservableList<GenreEntity> get availableGenres {
    _$availableGenresAtom.reportRead();
    return super.availableGenres;
  }

  @override
  set availableGenres(ObservableList<GenreEntity> value) {
    _$availableGenresAtom.reportWrite(value, super.availableGenres, () {
      super.availableGenres = value;
    });
  }

  late final _$selectedMoviesAtom = Atom(
    name: '_OnboardingStore.selectedMovies',
    context: context,
  );

  @override
  ObservableList<MovieEntity> get selectedMovies {
    _$selectedMoviesAtom.reportRead();
    return super.selectedMovies;
  }

  @override
  set selectedMovies(ObservableList<MovieEntity> value) {
    _$selectedMoviesAtom.reportWrite(value, super.selectedMovies, () {
      super.selectedMovies = value;
    });
  }

  late final _$selectedGenresAtom = Atom(
    name: '_OnboardingStore.selectedGenres',
    context: context,
  );

  @override
  ObservableList<GenreEntity> get selectedGenres {
    _$selectedGenresAtom.reportRead();
    return super.selectedGenres;
  }

  @override
  set selectedGenres(ObservableList<GenreEntity> value) {
    _$selectedGenresAtom.reportWrite(value, super.selectedGenres, () {
      super.selectedGenres = value;
    });
  }

  late final _$currentPageAtom = Atom(
    name: '_OnboardingStore.currentPage',
    context: context,
  );

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$isLoadingMoreAtom = Atom(
    name: '_OnboardingStore.isLoadingMore',
    context: context,
  );

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportRead();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.reportWrite(value, super.isLoadingMore, () {
      super.isLoadingMore = value;
    });
  }

  late final _$hasMorePagesAtom = Atom(
    name: '_OnboardingStore.hasMorePages',
    context: context,
  );

  @override
  bool get hasMorePages {
    _$hasMorePagesAtom.reportRead();
    return super.hasMorePages;
  }

  @override
  set hasMorePages(bool value) {
    _$hasMorePagesAtom.reportWrite(value, super.hasMorePages, () {
      super.hasMorePages = value;
    });
  }

  late final _$stepAtom = Atom(name: '_OnboardingStore.step', context: context);

  @override
  OnboardingStep get step {
    _$stepAtom.reportRead();
    return super.step;
  }

  @override
  set step(OnboardingStep value) {
    _$stepAtom.reportWrite(value, super.step, () {
      super.step = value;
    });
  }

  late final _$loadMoreMoviesAsyncAction = AsyncAction(
    '_OnboardingStore.loadMoreMovies',
    context: context,
  );

  @override
  Future<void> loadMoreMovies() {
    return _$loadMoreMoviesAsyncAction.run(() => super.loadMoreMovies());
  }

  late final _$saveSelectionsToStorageAsyncAction = AsyncAction(
    '_OnboardingStore.saveSelectionsToStorage',
    context: context,
  );

  @override
  Future<void> saveSelectionsToStorage() {
    return _$saveSelectionsToStorageAsyncAction.run(
      () => super.saveSelectionsToStorage(),
    );
  }

  late final _$_OnboardingStoreActionController = ActionController(
    name: '_OnboardingStore',
    context: context,
  );

  @override
  void initWithData(List<MovieEntity> movies, List<GenreEntity> genres) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.initWithData',
    );
    try {
      return super.initWithData(movies, genres);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleMovieSelection(MovieEntity movie) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.toggleMovieSelection',
    );
    try {
      return super.toggleMovieSelection(movie);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGenreSelection(GenreEntity genre) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.toggleGenreSelection',
    );
    try {
      return super.toggleGenreSelection(genre);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStep(OnboardingStep value) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.setStep',
    );
    try {
      return super.setStep(value);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadSelectionsFromStorage(
    List<MovieEntity> allMovies,
    List<GenreEntity> allGenres,
  ) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.loadSelectionsFromStorage',
    );
    try {
      return super.loadSelectionsFromStorage(allMovies, allGenres);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
availableMovies: ${availableMovies},
availableGenres: ${availableGenres},
selectedMovies: ${selectedMovies},
selectedGenres: ${selectedGenres},
currentPage: ${currentPage},
isLoadingMore: ${isLoadingMore},
hasMorePages: ${hasMorePages},
step: ${step},
canContinue: ${canContinue}
    ''';
  }
}
