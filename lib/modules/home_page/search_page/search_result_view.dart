import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/basic_state.dart';
import 'search_list_tile.dart';
import 'search_page_view_controller.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final searchPageViewController = context.read<SearchPageViewController>();
    
    final controller = ScrollController();
    return ValueListenableBuilder(
        valueListenable: searchPageViewController.state,
        builder: (_, state, __) {
          if (state == StateStaus.initial) {
            return Container();
          }
          if (state == StateStaus.loading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [Text('ရှာနေဆဲ'), CircularProgressIndicator()],
            );
          }
          if (state == StateStaus.nodata) {
            return Center(
              child: Text(
                '${searchPageViewController.textToHIghLight}ဟူသော စကားလုံး\nရှာမတွေ့ပါ။\n စာသားအပြောင်းအလဲ ပြုလုပ်၍ ထပ်မံရှာကြည့်ပါ။',
                textAlign: TextAlign.center,
              ),
            );
          }
          return DraggableScrollbar.semicircle(
            controller: controller,
            child: ListView.separated(
              controller: controller,
              itemCount: searchPageViewController.searchResults.length,
              itemBuilder: (_, index) {
                final word = searchPageViewController.searchResults[index];
                return SearchListTile(
                  word: word,
                  textToHighlight: searchPageViewController.textToHIghLight,
                  onClicked: () {
                    searchPageViewController.onSearchItemClicked(
                        context: context, word: word);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          );
        });
  }
}
