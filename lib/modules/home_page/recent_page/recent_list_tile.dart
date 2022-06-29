import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../models/recent.dart';

class RecentListTile extends StatelessWidget {
  const RecentListTile(
      {Key? key,
      required this.recent,
      this.isSelected = false,
      this.isSelectingMode = false,
      this.onTap,
      this.onLongPress,
      this.onDelete})
      : super(key: key);
  final Recent recent;
  final bool isSelected;
  final bool isSelectingMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        // key: ValueKey(recent.bookID),
        groupTag: 0,
        endActionPane: endActionPane(),
        child: Builder(
          // wrapping list tile in builder to access sliable by context
          builder: (context) => ListTile(
            onTap: () {
              final slidableController = Slidable.of(context)!;
              if (slidableController.direction.value == -1) {
                slidableController.close();
              } else if (onTap != null) {
                onTap!();
              }
            },
            onLongPress: onLongPress,
            selected: isSelected,
            leading: !isSelectingMode
                ? null
                : isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : const Icon(
                        CommunityMaterialIcons.checkbox_blank_circle_outline),
            title: Text(
              recent.word,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ));
  }

  ActionPane endActionPane() {
    return ActionPane(
      motion: const DrawerMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          //label: 'Archive',
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            if (onDelete != null) onDelete!();
          },
        ),
      ],
    );
  }
}
