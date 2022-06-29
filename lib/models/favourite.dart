import 'package:tipitakaabidan/models/recent.dart';

const String _jsonKeyWordId = 'word_id';
const String _jsonKeyWord = 'word';
const String _jsonKeyBookId = 'book_id';
const String _jsonKeyPageNumber = 'page_number';
const String _jsonKeyDateTime = 'date_time';

class Favourite extends Recent {
  Favourite({
    required int wordId,
    required String word,
    required String bookID,
    required int pageNumber,
    required DateTime dateTime,
  }) : super(
          wordId: wordId,
          word: word,
          bookID: bookID,
          pageNumber: pageNumber,
          dateTime: dateTime,
        );

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      wordId: json[_jsonKeyWordId] as int,
      word: json[_jsonKeyWord],
      bookID: json[_jsonKeyBookId],
      pageNumber: json[_jsonKeyPageNumber] as int,
      dateTime: DateTime.parse(json[_jsonKeyDateTime]),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return <String, dynamic>{
  //     _jsonKeyWordId: wordId,
  //     _jsonKeyWord: word,
  //     _jsonKeyBookId: bookID,
  //     _jsonKeyPageNumber: pageNumber,
  //     _jsonKeyDateTime: dateTime.toIso8601String(),
  //   };
  // }
}
