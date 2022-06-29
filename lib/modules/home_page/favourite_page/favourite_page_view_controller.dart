import 'package:flutter/material.dart';

import '../../../data/basic_state.dart';
import '../../../dialogs/confirm_dialog.dart';
import '../../../models/favourite.dart';
import '../../../repositories/favourite_repo.dart';
import '../../reader_page/reader_page.dart';

class FavouritePageViewController {
  FavouritePageViewController({
    required this.repository,
  });
  final FavouriteRepository repository;

  late final ValueNotifier<StateStaus> _state;
  ValueNotifier<StateStaus> get state => _state;

  final _isSelectionMode = ValueNotifier(false);
  ValueNotifier<bool> get isSelectionMode => _isSelectionMode;

  final _selectedItems = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> get selectedItems => _selectedItems;

  final List<Favourite> _favourites = [];
  List<Favourite> get favourites => _favourites;

  void onLoad() async {
    _state = ValueNotifier(StateStaus.loading);
    favourites.addAll(await _fetchBookmarks());
    if (favourites.isEmpty) {
      _state.value = StateStaus.nodata;
    } else {
      _state.value = StateStaus.data;
    }
  }

  void dispose() {
    _state.dispose();
    _isSelectionMode.dispose();
    _selectedItems.dispose();
  }

  Future<List<Favourite>> _fetchBookmarks() async {
    return await repository.getFavourites();
  }

  Future<void> _refresh() async {
    _state.value = StateStaus.loading;
    _favourites.clear();
    _favourites.addAll(await _fetchBookmarks());
    if (favourites.isEmpty) {
      _state.value = StateStaus.nodata;
    } else {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onBookmarkItemClicked(BuildContext context, int index) async {
    if (!_isSelectionMode.value) {
      // opening book
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReaderPage(
                  wordId: _favourites[index].wordId,
                  word: _favourites[index].word,
                  bookId: _favourites[index].bookID,
                  pageNumber: _favourites[index].pageNumber))).then((_) {
        _refresh();
      });
      return;
    }
    if (!_selectedItems.value.contains(index)) {
      _selectedItems.value = [..._selectedItems.value, index];
      return;
    }

    // remove form selected items
    _selectedItems.value.remove(index);
    _selectedItems.value = [..._selectedItems.value];
    // update selection mode
    if (_selectedItems.value.isEmpty) {
      _isSelectionMode.value = false;
    }
  }

  void onBookmarktemPressed(BuildContext context, int index) {
    if (!_isSelectionMode.value) {
      _isSelectionMode.value = true;
      _selectedItems.value = [index];
    }
  }

  void onCancelButtonClicked() {
    // chnage mode
    _isSelectionMode.value = false;
    // clear selected items
    _selectedItems.value = [];
  }

  void onSelectAllButtonClicked() {
    if (_favourites.length == _selectedItems.value.length) {
      // deselecting all
      _selectedItems.value = [];
      _isSelectionMode.value = false;
    } else {
      // selecting all
      _selectedItems.value =
          List.generate(_favourites.length, (index) => index);
    }
  }

  Future<void> onDeleteActionClicked(int index) async {
    _state.value = StateStaus.loading;
    // deleting record
    await repository.delete(_favourites[index]);
    // deleting from loaded
    _favourites.removeAt(index);
    if (_favourites.isEmpty) {
      _state.value = StateStaus.nodata;
    } else {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onDeleteButtonClicked(BuildContext context) async {
    final userActions = await _getComfirmation(context);
    if (userActions == null || userActions == OkCancelAction.cancel) {
      _selectedItems.value = [];
      _isSelectionMode.value = false;
      return;
    }

    // chanage state to loading
    _state.value = StateStaus.loading;
    if (_favourites.length == _selectedItems.value.length) {
      await repository.deleteAll();
      _favourites.clear();
      _selectedItems.value = [];
      _isSelectionMode.value = false;
      _state.value = StateStaus.nodata;
    } else {
      await repository.deletes(
          _getSelectedBookmarksFrom(selectedItems: _selectedItems.value));
      _favourites.clear();
      _favourites.addAll(await repository.getFavourites());
      _selectedItems.value = [];
      _isSelectionMode.value = false;
      _state.value = StateStaus.data;
    }
  }

  List<Favourite> _getSelectedBookmarksFrom(
      {required List<int> selectedItems}) {
    return selectedItems.map((index) => _favourites[index]).toList();
  }

  Future<OkCancelAction?> _getComfirmation(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            message: 'မှတ်သားထားသော မှတ်စုများကို ဖျက်ရန် သေချာပြီလား',
            okLabel: 'ဖျက်မယ်',
            cancelLabel: 'မဖျက်တော့ဘူး',
          );
        });
  }
}
