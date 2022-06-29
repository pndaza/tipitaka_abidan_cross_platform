import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../data/basic_state.dart';
import '../../data/constants.dart';
import '../../data/shared_pref_client.dart';
import '../../models/book.dart';
import '../../models/favourite.dart';
import '../../packages/native_pdf_renderer/pdf_page_view.dart';
import '../../repositories/book_repo.dart';
import '../../repositories/favourite_repo.dart';

class ReaderViewController {
  ReaderViewController({
    required this.wordId,
    required this.word,
    required this.bookId,
    required this.pageNumber,
    required this.bookRepository,
    required this.favouriteRepository,
  });
  final int wordId;
  final String word;
  final String bookId;
  final int pageNumber;
  final BookRepository bookRepository;
  final FavouriteRepository favouriteRepository;

  late final Book _book;
  late final String assetsPath;

  late List<Favourite> _favourites;

  final _stateStatus = ValueNotifier(StateStaus.loading);
  ValueNotifier<StateStaus> get stateStatus => _stateStatus;

  String get bookName => _book.name;

  late final int _initialPage;
  int get initialPage => _initialPage;

  late final ValueNotifier<bool> _isAddedFavourite;
  ValueListenable<bool> get isAddedFavourite => _isAddedFavourite;

  late final ValueNotifier<Axis> _scrollDirection;
  ValueListenable<Axis> get scrollDirection => _scrollDirection;

  late final ValueNotifier<ColorMode> _colorMode;
  ValueListenable<ColorMode> get colorMode => _colorMode;

  void onLoad() async {
    assetsPath = join(AssetsInfo.baseAssetsPath, AssetsInfo.bookAssetPath,
        AssetsInfo.bookPdfPath, '$bookId.pdf');
    // loading book info
    _book = await _getBookInfo(bookId);
    // calulate pdf page number
    if (pageNumber == 0) {
      _initialPage = 0;
    } else {
      _initialPage = pageNumber + _book.startPage;
    }

    //
    _favourites = await favouriteRepository.getFavourites();
    if (_favourites.map((element) => element.wordId).contains(wordId)) {
      _isAddedFavourite = ValueNotifier(true);
    } else {
      _isAddedFavourite = ValueNotifier(false);
    }
    // initialize scroll direction from sharedpref
    final scrollModeIndex = SharedPreferenceClient.scrollDirectionIndex;
    final scrollMode = Axis.values[scrollModeIndex];
    _scrollDirection = ValueNotifier<Axis>(scrollMode);
    _stateStatus.value = StateStaus.data;

    final colorModeIndex = SharedPreferenceClient.pdfThemeModeIndex;
    final colorMode = ColorMode.values[colorModeIndex];
    _colorMode = ValueNotifier(colorMode);
  }

  Future<Book> _getBookInfo(String bookId) async {
    return await bookRepository.fetchBookInfo(bookId);
  }

  Future<void> onClickedFavourite() async {
    _isAddedFavourite.value = !_isAddedFavourite.value;
    final favourite = Favourite(
      wordId: wordId,
      word: word,
      bookID: bookId,
      pageNumber: pageNumber,
      dateTime: DateTime.now(),
    );
    // save
    if (_isAddedFavourite.value) {
      await favouriteRepository.insert(favourite);
    } else {
      await favouriteRepository.delete(favourite);
    }
  }

  void onToggleScrollMode() {
    if (_scrollDirection.value == Axis.vertical) {
      _scrollDirection.value = Axis.horizontal;
    } else {
      _scrollDirection.value = Axis.vertical;
    }

    // save
    SharedPreferenceClient.scrollDirectionIndex = _scrollDirection.value.index;
  }

  void onChangedColorMode(ColorMode colorMode) {
    _colorMode.value = colorMode;
    SharedPreferenceClient.pdfThemeModeIndex = colorMode.index;
  }
}
