import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../widgets/multi_value_listenable_builder.dart';
import 'recent_list_tile.dart';
import 'recent_page_view_controller.dart';

class RecentlistView extends StatelessWidget {
  const RecentlistView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RecentPageViewController>();
    final recents = controller.recents;
    return ValueListenableBuilder2<bool, List<int>>(
        first: controller.isSelectionMode,
        second: controller.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              itemCount: recents.length,
              itemBuilder: (_, index) => RecentListTile(
                recent: recents.elementAt(index),
                isSelectingMode: isSelectionMode,
                isSelected: selectedItems.contains(index),
                onTap: () => controller.onRecentItemClicked(context, index),
                onLongPress: () =>
                    controller.onRecentItemPressed(context, index),
                onDelete: () => controller
                    .onDeleteActionClicked(index),
              ),
              separatorBuilder: (_, __) => const Divider(),
            ),
          );
        });
  }
}
