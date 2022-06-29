// import 'package:flutter/material.dart';

// import 'reader_view_controller.dart';

// class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String bookID;
//   final String? bookName;

//   const ReaderAppBar({Key? key, required this.bookID, this.bookName})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final scrollDirection = ref.watch(scrollDirectionProvider);
//     final isFullScreenMode = ref.watch(fullScreenStateProvider);

//     if (isFullScreenMode) {
//       final statusBarHeight = MediaQuery.of(context).padding.top;
//       return Container(
//         height: statusBarHeight,
//       );
//     }

//     return AppBar(
//       title: Text(bookName ?? ''),
//       centerTitle: true,
//       actions: [
//         IconButton(
//             icon: Icon(scrollDirection == Axis.horizontal
//                 ? Icons.swap_horiz
//                 : Icons.swap_vert),
//             onPressed: () async {
// //
//             })
//       ],
//     );
//   }

//   @override
//   Size get preferredSize {
//     return Size.fromHeight(AppBar().preferredSize.height);
//   }
// }
