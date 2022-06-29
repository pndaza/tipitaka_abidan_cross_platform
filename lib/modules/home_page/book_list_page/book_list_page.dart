import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/theme_controller.dart';
import '../../../data/basic_state.dart';
import '../../../widgets/loading_view.dart';
import 'book_list_view_controller.dart';
import 'widgets/book_list_view.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<BookListViewController>(
      create: (_) => BookListViewController(),
      builder: (context, __) => Scaffold(
        appBar: AppBar(
          title: const Text('တိပိဋက ပါဠိ-မြန်မာ အဘိဓာန်'),
          centerTitle: true,
          actions: _actions(context),
        ),
        body: ValueListenableBuilder<StateStaus>(
          valueListenable: context.read<BookListViewController>().state,
          builder: (_, value, __) {
            if (value == StateStaus.loading) {
              return const LoadingView();
            }
            return BookListView(
                books: context.read<BookListViewController>().books);
          },
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    return <Widget>[
      AppPopupMenu<ThemeMode>(
        icon: const Icon(Icons.palette_outlined),
        initialValue: context.read<ThemeController>().themeMode.value,
        menuItems: const [
          PopupMenuItem(
            value: ThemeMode.light,
            child: Text('နေ့'),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Text('ည'),
          ),
          PopupMenuItem(
            value: ThemeMode.system,
            child: Text('စက်'),
          ),
        ],
        elevation: 3.0,
        offset: const Offset(36, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onSelected: context.read<ThemeController>().onChangedThemeMode,
      ),
      IconButton(
          onPressed: () async => context
              .read<BookListViewController>()
              .onSettingIconClicked(context: context),
          icon: const Icon(Icons.info_outlined)),
    ];
  }
}
