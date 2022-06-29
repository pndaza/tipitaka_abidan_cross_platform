import 'package:flutter/material.dart';

import '../../../../models/book.dart';

class BookListTile extends StatelessWidget {
  const BookListTile(
      {Key? key, required this.book, required this.path, this.onTap})
      : super(key: key);
  final Book book;
  final String path;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shadowColor: Colors.brown,
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                path,
                // width: 200,
                // height: 350,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              Text(book.name),
              FittedBox(child: Text(book.nameInfo)),
            ],
          ),
        ),
      ),
    );
  }
}
