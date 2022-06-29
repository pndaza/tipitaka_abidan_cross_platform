import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/basic_state.dart';
import '../../../repositories/favourite_repo.dart';
import '../../../widgets/loading_view.dart';
import 'favourite_list_view.dart';
import 'favourite_page_app_bar.dart';
import 'favourite_page_view_controller.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<FavouritePageViewController>(
        create: (_) =>
            FavouritePageViewController(repository: PrefFavouriteRepository())
              ..onLoad(),
        dispose: (context, value) => value.dispose(),
        builder: (context, __) => Scaffold(
              appBar: const FavouritePageAppBar(),
              body: ValueListenableBuilder<StateStaus>(
                  valueListenable:
                      context.watch<FavouritePageViewController>().state,
                  builder: (_, state, __) {
                    if (state == StateStaus.loading) {
                      return const LoadingView();
                    }

                    if (state == StateStaus.nodata) {
                      return const Center(
                        child: Text('မှတ်ထားသောပုဒ်များ\nမရှိသေးပါ'),
                      );
                    }
                    return FavouritelistView(
                        bookmarks: context
                            .watch<FavouritePageViewController>()
                            .favourites);
                  }),
            ));
  }
}
