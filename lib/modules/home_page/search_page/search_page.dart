import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repositories/database.dart';
import '../../../repositories/recent_repo.dart';
import '../../../repositories/word_dao.dart';
import '../../../repositories/word_repo.dart';
import '../../../widgets/common_extension_widgets.dart';
import 'search_bar.dart';
import 'search_mode_view.dart';
import 'search_page_view_controller.dart';
import 'search_result_view.dart';

class SerachPage extends StatelessWidget {
  const SerachPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<SearchPageViewController>(
        create: (_) => SearchPageViewController(
              wordRepository:
                  DatabaseWordRepository(DatabaseHelper(), WordDao()),
              recentRepository:
                 PrefRecentRepository(),
            )..onLoad(),
        builder: (context, __) {
          final viewController = context.read<SearchPageViewController>();
          return Scaffold(
            appBar: AppBar(title: const Text('တည်ပုဒ်ရှာဖွေ')),
            body: Column(
              children: [
                SearchModeView(
                    searchMode: viewController.searchMode.value,
                    onChanged: (value) {
                      viewController.onSearchModeChanged(value);
                    }).padding(),
                const Expanded(child: SearchResultView()),
                SearchBar(
                  onChanged: viewController.onSearchTextChanged,
                )
              ],
            ),
          );
        });
  }
}
