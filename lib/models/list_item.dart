import 'package:flutter/material.dart';
import 'book.dart';

import 'category.dart';

abstract class ListItem {
  Widget build(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class CategoryItem implements ListItem {
  final Category category;

  const CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(category.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )));
  }
}

/// A ListItem that contains data to display a message.
class BookItem implements ListItem {
  final Book book;

  const BookItem(this.book);

  @override
  Widget build(BuildContext context) => Text(
        book.name,
        style: const TextStyle(fontSize: 20),
      );
}
