import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitakaabidan/repositories/recent_repo.dart';

import '../../../data/basic_state.dart';
import '../../../widgets/loading_view.dart';
import 'recent_list_view.dart';
import 'recent_page_app_bar.dart';
import 'recent_page_view_controller.dart';

class RecentPage extends StatelessWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<RecentPageViewController>(
        create: (_) => RecentPageViewController(
              recentRepository: PrefRecentRepository(),
            )..onLoad(),
        dispose: (context, value) => value.dispose(),
        builder: (context, __) => Scaffold(
              appBar: const RecentPageAppBar(),
              body: ValueListenableBuilder<StateStaus>(
                  valueListenable:
                      context.read<RecentPageViewController>().state,
                  builder: (_, state, __) {
                    if (state == StateStaus.loading) {
                      return const LoadingView();
                    }
                    if (state == StateStaus.nodata) {
                      return const Center(
                        child: Text('ကြည့်ခဲ့သောပုဒ်များ\nမရှိသေးပါ'),
                      );
                    }
                    return RecentlistView(
                        recents:
                            context.read<RecentPageViewController>().recents);
                  }),
            ));
  }
}
