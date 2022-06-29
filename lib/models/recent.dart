const String _jsonKeyWordId = 'word_id';
const String _jsonKeyWord = 'word';
const String _jsonKeyBookId = 'book_id';
const String _jsonKeyPageNumber = 'page_number';
const String _jsonKeyDateTime = 'date_time';

class Recent {
  final int wordId;
  final String word;
  final String bookID;
  final int pageNumber;
  final DateTime dateTime;
  Recent({
    required this.wordId,
    required this.word,
    required this.bookID,
    required this.pageNumber,
    required this.dateTime,
  });

  factory Recent.fromJson(Map<String, dynamic> json) {
    return Recent(
      wordId: json[_jsonKeyWordId] as int,
      word: json[_jsonKeyWord],
      bookID: json[_jsonKeyBookId],
      pageNumber: json[_jsonKeyPageNumber] as int,
      dateTime: DateTime.parse(json[_jsonKeyDateTime]),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _jsonKeyWordId: wordId,
      _jsonKeyWord: word,
      _jsonKeyBookId: bookID,
      _jsonKeyPageNumber: pageNumber,
      _jsonKeyDateTime: dateTime.toIso8601String(),
    };
  }
}
