import 'package:flutter/material.dart';

import '../../../data/basic_state.dart';
import '../../../data/shared_pref_client.dart';
import '../../../models/recent.dart';
import '../../../models/word.dart';
import '../../../repositories/recent_repo.dart';
import '../../../repositories/word_repo.dart';
import '../../reader_page/reader_page.dart';

class SearchPageViewController {
  SearchPageViewController({
    required this.wordRepository,
    required this.recentRepository,
  });

  final WordRepository wordRepository;
  final RecentRepository recentRepository;

  //
  final ValueNotifier<StateStaus> _state =
      ValueNotifier<StateStaus>(StateStaus.initial);
  ValueNotifier<StateStaus> get state => _state;

  late final ValueNotifier<SearchMode> _searchMode;
  ValueNotifier<SearchMode> get searchMode => _searchMode;

  final List<Word> _searchResults = [];
  List<Word> get searchResults => _searchResults;

  String _textToHightLight = '';

  String get textToHIghLight => _textToHightLight;

  void onLoad() {
    final index = SharedPreferenceClient.searchModeIndex;
    final searchMode = SearchMode.values[index];
    _searchMode = ValueNotifier<SearchMode>(searchMode);
  }

  void dispose() {
    _state.dispose();
    _searchMode.dispose();
  }

  void onSearchModeChanged(SearchMode searchMode) {
    _searchMode.value = searchMode;
    if (_textToHightLight.isEmpty) {
      return;
    }

    _doSearch(_textToHightLight);
  }

  void onSearchTextChanged(String searchWord) async {
    if (searchWord.isEmpty) {
      _state.value = StateStaus.initial;
      return;
    }
    _textToHightLight = searchWord;
    // searchWord = MMStringNormalizer.normalize(searchWord);
    _doSearch(searchWord);
  }

  Future<void> _doSearch(String searchWord) async {
    _state.value = StateStaus.loading;
    final results = await wordRepository.getWords(
        word: searchWord, searchMode: _searchMode.value);
    debugPrint('search results: ${results.length}');
    if (results.isEmpty) {
      _searchResults.clear();
      _state.value = StateStaus.nodata;
    } else {
      _searchResults.clear();
      _searchResults.addAll(results);
      _state.value = StateStaus.data;
    }
  }

  void onSearchItemClicked(
      {required BuildContext context, required Word word}) async {
    // save to recent
    final recent = Recent(
      wordId: word.id,
      word: word.word,
      bookID: word.bookId,
      pageNumber: word.pageNumber,
      dateTime: DateTime.now(),
    );
    await recentRepository.insertOrReplace(recent);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderPage(
                  wordId: word.id,
                  word: word.word,
                  bookId: word.bookId,
                  pageNumber: word.pageNumber,
                )));
  }
}
