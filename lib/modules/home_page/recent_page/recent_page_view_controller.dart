import 'package:flutter/material.dart';

import '../../../data/basic_state.dart';
import '../../../dialogs/confirm_dialog.dart';
import '../../../models/recent.dart';
import '../../../repositories/recent_repo.dart';
import '../../reader_page/reader_page.dart';

class RecentPageViewController {
  RecentPageViewController({
    required this.recentRepository,
  });
  final RecentRepository recentRepository;

  final _state = ValueNotifier(StateStaus.loading);
  ValueNotifier<StateStaus> get state => _state;

  final _isSelectionMode = ValueNotifier(false);
  ValueNotifier<bool> get isSelectionMode => _isSelectionMode;

  final _selectedItems = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> get selectedItems => _selectedItems;

  final List<Recent> _recents = [];
  List<Recent> get recents => _recents;

  void onLoad() async {
    final recents = await recentRepository.getRecents();
    _recents.addAll(recents);
    if (recents.isEmpty) {
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

  Future<void> _refresh() async {
    _state.value = StateStaus.loading;
    _recents.clear();
    _recents.addAll(await recentRepository.getRecents());
    if (recents.isEmpty) {
      _state.value = StateStaus.nodata;
    }
    {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onRecentItemClicked(BuildContext context, int index) async {
    if (!_isSelectionMode.value) {
      // opening book
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReaderPage(
                  wordId: _recents[index].wordId,
                  word: _recents[index].word,
                  bookId: _recents[index].bookID,
                  pageNumber: _recents[index].pageNumber))).then((value) {
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

  void onRecentItemPressed(BuildContext context, int index) {
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
    if (_recents.length == _selectedItems.value.length) {
      // deselecting all
      _selectedItems.value = [];
      _isSelectionMode.value = false;
    } else {
      // selecting all
      _selectedItems.value = List.generate(_recents.length, (index) => index);
    }
  }

  Future<void> onDeleteActionClicked(int index) async {
    _state.value = StateStaus.loading;
    // deleting record
    await recentRepository.delete(_recents[index]);
    // deleting from loaded
    _recents.removeAt(index);
    if (_recents.isEmpty) {
      _state.value = StateStaus.nodata;
    } else {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onDeleteButtonClicked(BuildContext context) async {
    final userActions = await _getComfirmation(context);
    if (userActions == null || userActions == OkCancelAction.cancel) {
      _isSelectionMode.value = false;
      _selectedItems.value = [];
      return;
    }

    // chanage state to loading
    _state.value = StateStaus.loading;
    if (_recents.length == _selectedItems.value.length) {
      await recentRepository.deleteAll();
      _recents.clear();
      _selectedItems.value = [];
      _isSelectionMode.value = false;
      _state.value = StateStaus.nodata;
    } else {
      await recentRepository.deletes(
          _getSelectedRecentsFrom(selectedItems: _selectedItems.value));
      _recents.clear();
      _recents.addAll(await recentRepository.getRecents());
      _selectedItems.value = [];
      _isSelectionMode.value = false;
      _state.value = StateStaus.data;
    }
  }

  List<Recent> _getSelectedRecentsFrom({required List<int> selectedItems}) {
    return selectedItems.map((index) => _recents[index]).toList();
  }

  Future<OkCancelAction?> _getComfirmation(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            message: 'ဖတ်ဆဲ စာအုပ်စာရင်း များကို ဖျက်ရန် သေချာပြီလား',
            okLabel: 'ဖျက်မယ်',
            cancelLabel: 'မဖျက်တော့ဘူး',
          );
        });
  }
}
