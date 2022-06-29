import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tipitakaabidan/data/constants.dart';
import 'package:tipitakaabidan/models/book.dart';

import '../book_list_view_controller.dart';
import 'book_list_tile.dart';

class BookListView extends StatelessWidget {
  const BookListView({Key? key, required this.books}) : super(key: key);
  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width > 600 && width < 800) {
      crossAxisCount = 3;
    } else if (width > 800) {
      crossAxisCount = 4;
    }

    return GridView.builder(
      // padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.51,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookListTile(
            book: book,
            path: "${AssetsInfo.baseAssetsPath}/${AssetsInfo.bookAssetPath}/${AssetsInfo.bookCoverPath}/book_cover_${book.id}.png",
            onTap: () => context
                .read<BookListViewController>()
                .onBookItemClicked(context, book));
      },
    );
  }
}
