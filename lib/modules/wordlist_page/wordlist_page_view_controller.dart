import 'package:flutter/material.dart';

import '../../data/basic_state.dart';
import '../../models/book.dart';
import '../../models/recent.dart';
import '../../models/word.dart';
import '../../repositories/database.dart';
import '../../repositories/recent_repo.dart';
import '../../repositories/word_dao.dart';
import '../../repositories/word_repo.dart';
import '../reader_page/reader_page.dart';

class WordlistPageViewController {
  WordlistPageViewController({
    required this.book,
    required this.recentRepository,
  });

  final Book book;
  final RecentRepository recentRepository;

  final _stateStatus = ValueNotifier<StateStaus>(StateStaus.loading);
  ValueNotifier<StateStaus> get stateStaus => _stateStatus;

  final List<Word> wordlist = [];

  void onLoad() async {
    wordlist.addAll(await _getWordlist(book.id));
    _stateStatus.value = StateStaus.data;
  }

  Future<List<Word>> _getWordlist(String bookId) async {
    WordRepository repository =
        DatabaseWordRepository(DatabaseHelper(), WordDao());
    return await repository.fetchWordlist(bookId);
  }

  void onCoverItemClicked(BuildContext context) {
    // use 0 for cover page
    _navigateToReaderPage(
      context: context,
      wordId: 0,
      word: '',
      bookId: book.id,
      initialPage: 0,
    );
  }

  void onWordListItemClicked(BuildContext context, Word word) async {
    // save to recent
    final recent = Recent(
      wordId: word.id,
      word: word.word,
      bookID: word.bookId,
      pageNumber: word.pageNumber,
      dateTime: DateTime.now(),
    );
    await recentRepository.insertOrReplace(recent);
    //
    _navigateToReaderPage(
      context: context,
      wordId: word.id,
      word: word.word,
      bookId: word.bookId,
      initialPage: word.pageNumber,
    );
  }

  void _navigateToReaderPage({
    required BuildContext context,
    required int wordId,
    required String word,
    required String bookId,
    required int initialPage,
  }) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderPage(
                  wordId: wordId,
                  word: word,
                  bookId: bookId,
                  pageNumber: initialPage,
                )));
  }
}
