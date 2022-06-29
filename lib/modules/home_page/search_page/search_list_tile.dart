import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../models/word.dart';

class SearchListTile extends StatelessWidget {
  final Word word;
  final String textToHighlight;
  final VoidCallback? onClicked;

  const SearchListTile(
      {Key? key,
      required this.word,
      required this.textToHighlight,
      this.onClicked})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClicked,
      dense: true,
      title: SubstringHighlight(
        text: word.word,
        textStyle: TextStyle(
            fontSize: 18, color: Theme.of(context).textTheme.bodyText2?.color!),
        term: textToHighlight,
        textStyleHighlight: TextStyle(
            fontSize: 18, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
