import 'package:flutter/material.dart';

import '../../../data/basic_state.dart';
import '../../../models/book.dart';
import '../../../repositories/book_dao.dart';
import '../../../repositories/book_repo.dart';
import '../../../repositories/database.dart';
import '../../info/info_page.dart';
import '../../wordlist_page/wordlist_page.dart';

class BookListViewController {
  BookListViewController() {
    _init();
  }

  final _state = ValueNotifier<StateStaus>(StateStaus.loading);
  ValueNotifier<StateStaus> get state => _state;

  final List<Book> _books = [];
  List<Book> get books => _books;

  void _init() {
    _loadBooks().then((value) {
      _books.addAll(value);
      _state.value = StateStaus.data;
    });
  }

  void dispose() {
    _state.dispose();
  }

  Future<List<Book>> _loadBooks() async {
    BookRepository repository =
        DatabaseBookRepository(DatabaseHelper(), BookDao());
    return await repository.fetchBooks();
  }

  void onBookItemClicked(BuildContext context, Book book) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => WordlistPage(
                  book: book,
                )));
  }

  Future<void> onSettingIconClicked({required BuildContext context}) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoPage()));
  }
}
