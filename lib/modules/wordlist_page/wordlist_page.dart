import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../../data/basic_state.dart';
import '../../models/book.dart';
import '../../repositories/recent_repo.dart';
import '../../widgets/loading_view.dart';
import 'wordlist_page_view_controller.dart';
import 'worlist_view.dart';

class WordlistPage extends StatelessWidget {
  const WordlistPage({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Provider<WordlistPageViewController>(
      create: (_) => WordlistPageViewController(
        book: book,
        recentRepository: PrefRecentRepository(),
      )..onLoad(),
      builder: (context, __) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: Platform.isMacOS ? 18.0 : 0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
          title: Text(book.name),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<StateStaus>(
          valueListenable:
              context.read<WordlistPageViewController>().stateStaus,
          builder: (_, value, __) {
            if (value == StateStaus.loading) {
              return const LoadingView();
            }
            return WordlistView(
                wordlist: context.read<WordlistPageViewController>().wordlist);
          },
        ),
      ),
    );
  }
}
