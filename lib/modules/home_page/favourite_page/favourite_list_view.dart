import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../models/favourite.dart';
import '../../../widgets/multi_value_listenable_builder.dart';
import 'favourite_list_tile.dart';
import 'favourite_page_view_controller.dart';

class FavouritelistView extends StatelessWidget {
  const FavouritelistView({Key? key, required this.bookmarks}) : super(key: key);
  final List<Favourite> bookmarks;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FavouritePageViewController>();
    final bookmarks = controller.favourites;
    return ValueListenableBuilder2<bool, List<int>>(
        first: controller.isSelectionMode,
        second: controller.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              itemCount: bookmarks.length,
              itemBuilder: (_, index) => FavouriteListTile(
                bookmark: bookmarks.elementAt(index),
                isSelectingMode: isSelectionMode,
                isSelected: selectedItems.contains(index),
                onTap: () => controller.onBookmarkItemClicked(context, index),
                onLongPress: () =>
                    controller.onBookmarktemPressed(context, index),
                onDelete: () => controller
                    .onDeleteActionClicked(index),
              ),
              separatorBuilder: (_, __) => const Divider(),
            ),
          );
        });
      
  }
}
