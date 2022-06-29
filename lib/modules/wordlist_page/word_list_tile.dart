import 'package:flutter/material.dart';

import '../../models/word.dart';

class WordListTile extends StatelessWidget {
  final Word word;
  final VoidCallback? onTap;
  const WordListTile({
    Key? key,
    required this.word,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        elevation: 2.0,
        child: ListTile(
          onTap: onTap,
          title: Text(
            word.word,
            style: Theme.of(context).textTheme.headline6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
