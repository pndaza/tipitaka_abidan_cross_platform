import 'book.dart';

class SearchResult {
  final Book book;
  final int pageNumber;
  final String description;
  final String textToHighlight;
  SearchResult({
    required this.book,
    required this.pageNumber,
    required this.description,
    required this.textToHighlight,
  });

}
