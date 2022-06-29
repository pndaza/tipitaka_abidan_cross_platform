import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.hint = 'စာရှာလိုရာစာလုံးရိုက်ပါ',
    this.onChanged,
    this.onSummited,
  }) : super(key: key);
  final String hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSummited;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController textEditingController = TextEditingController();
  bool hasText = false;
  @override
  void initState() {
    // textEditingController = TextEditingController();
    textEditingController.addListener(() {
      setState(() {
        hasText = textEditingController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      height: 56.0,
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: textEditingController,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSummited,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintStyle: TextStyle(color: Colors.grey),
            ),
          )),
          hasText
              ? ClearButton(onClicked: () {
                  textEditingController.clear();
                  if (widget.onChanged != null) {
                    widget.onChanged!('');
                  }
                })
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton({Key? key, required this.onClicked}) : super(key: key);
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClicked,
      icon: const Icon(Icons.clear_rounded),
    );
  }
}
