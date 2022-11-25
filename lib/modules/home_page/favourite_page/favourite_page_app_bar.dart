import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/mm_number.dart';
import '../../../widgets/multi_value_listenable_builder.dart';
import 'favourite_page_view_controller.dart';

class FavouritePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavouritePageAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = context.read<FavouritePageViewController>();
    return ValueListenableBuilder2<bool, List<int>>(
        first: controller.isSelectionMode,
        second: controller.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          if (!isSelectionMode || controller.selectedItems.value.isEmpty) {
            return AppBar(
              title: const Text('မှတ်သားထားသောပုဒ်များ'),
              centerTitle: true,
            );
          } else {
            return AppBar(
              leading: Padding(
                padding: EdgeInsets.only(top: Platform.isMacOS ? 18.0 : 0),
                child: IconButton(
                    onPressed: controller.onCancelButtonClicked,
                    icon: const Icon(Icons.cancel_outlined)),
              ),
              title: Text('${MmNumber.get(selectedItems.length)} ခု မှတ်ထား'),
              centerTitle: true,
              actions: <Widget>[
                // select all button
                IconButton(
                    onPressed: controller.onSelectAllButtonClicked,
                    icon: Icon(
                      Icons.select_all_outlined,
                      color: controller.favourites.length == selectedItems.length
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary,
                    )),
                // delete button
                IconButton(
                    onPressed: selectedItems.isEmpty
                        ? null
                        : () => controller.onDeleteButtonClicked(context),
                    icon: const Icon(Icons.delete_outline_outlined)),
              ],
            );
          }
        });
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
