import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../repositories/word_repo.dart';

class SearchModeView extends StatefulWidget {
  const SearchModeView({
    Key? key,
    required this.searchMode,
    this.onChanged,
  }) : super(key: key);
  final SearchMode searchMode;
  final ValueChanged<SearchMode>? onChanged;

  @override
  State<SearchModeView> createState() => _SearchModeViewState();
}

class _SearchModeViewState extends State<SearchModeView> {
  late int selectedSearchModeIndex;

  @override
  void initState() {
    super.initState();
    selectedSearchModeIndex = widget.searchMode.index;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: selectedSearchModeIndex,
      activeBgColor: const [Colors.teal],
      minWidth: 100,
      totalSwitches: 2,
      labels: const ['အစတူ', 'နေရာမရွေး'],
      onToggle: (index) {
        if (index != null && widget.onChanged != null) {
          widget.onChanged!(SearchMode.values[index]);
        }
      },
    );
  }
}
