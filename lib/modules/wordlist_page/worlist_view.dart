import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/word.dart';
import '../../widgets/common_extension_widgets.dart';
import 'word_list_tile.dart';
import 'wordlist_page_view_controller.dart';

class WordlistView extends StatefulWidget {
  final List<Word> wordlist;
  const WordlistView({
    Key? key,
    required this.wordlist,
  }) : super(key: key);

  @override
  State<WordlistView> createState() => _WordlistViewState();
}

class _WordlistViewState extends State<WordlistView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            'မျက်နှာဖုံးနှင့်နိဒါန်း',
            style: Theme.of(context).textTheme.titleLarge,
          ).center(),
          onTap: () => context
              .read<WordlistPageViewController>()
              .onCoverItemClicked(context),
        ),
        Expanded(
          child: DraggableScrollbar.semicircle(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.wordlist.length,
              itemBuilder: (_, index) => WordListTile(
                onTap: () => context
                    .read<WordlistPageViewController>()
                    .onWordListItemClicked(context, widget.wordlist[index]),
                word: widget.wordlist[index],
              ),
              itemExtent: 64,
            ),
          ),
        ),
      ],
    );
  }
}
