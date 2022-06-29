import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

enum GotoType { page, paragraph }

class GotoDialogResult {
  final int number;
  final GotoType type;
  GotoDialogResult(this.number, this.type);
}

class GotoDialog extends StatefulWidget {
  final int firstPage;
  final int lastPage;
  final int firstParagraph;
  final int lastParagraph;
  final double radius;

  const GotoDialog(
      {Key? key,
      required this.firstPage,
      required this.lastPage,
      required this.firstParagraph,
      required this.lastParagraph,
      this.radius = 16.0})
      : super(key: key);

  @override
  _GotoDialogState createState() => _GotoDialogState();
}

class _GotoDialogState extends State<GotoDialog> {
  TextEditingController controller = TextEditingController();
  GotoType selectedType = GotoType.page;
  int? selectedTypeIndex;
  String? hintText;
  bool isValid = false;

  _GotoDialogState();

  @override
  void initState() {
    super.initState();
    hintText = 'page (${widget.firstPage}-${widget.lastPage})';
    selectedTypeIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Dialog(
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(widget.radius)),
          elevation: 10.0,
          child: dialogContent(),
        ),
      ),
    );
  }

  Widget dialogContent() {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTitle(),
          const Divider(),
          _buildInputType(context),
          _buildInputField(),
          _buildActions(context)
        ],
      ),
    );
  }

  Padding _buildTitle() {
    return const Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        'သို့',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  ToggleSwitch _buildInputType(BuildContext context) {
    return ToggleSwitch(
      totalSwitches: 2,
      labels: const ['စာမျက်နှာ', 'စာပိုဒ်'],
      initialLabelIndex: selectedTypeIndex!,
      onToggle: (index) {
        setState(() {
          selectedTypeIndex = index;
          if (index == 0) {
            selectedType = GotoType.page;
            hintText = 'page (${widget.firstPage}-${widget.lastPage})';
          } else {
            selectedType = GotoType.paragraph;
            hintText =
                'paragraph (${widget.firstParagraph}-${widget.lastParagraph})';
          }
        });
      },
      // activeBgColor: Theme.of(context).accentColor,
      minWidth: 100.0,
    );
  }

  Padding _buildInputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
        onChanged: _validate,
        keyboardType: TextInputType.number,
        autofocus: false,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonTextTheme: ButtonTextTheme.accent,
      buttonMinWidth: 120.0,
      children: [
        TextButton(
          child: const Text(
            'မသွားတော့ဘူး',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
            child: const Text(
              'သွားမယ်',
            ),
            onPressed: !isValid
                ? null
                : () {
                    final result = GotoDialogResult(
                        int.parse(controller.text), selectedType);
                    Navigator.pop(context, result);
                  }),
      ],
    );
  }

  void _validate(String input) {
    setState(() {
      if (input.isEmpty) {
        isValid = false;
      } else {
        final inputNumber = int.parse(input);
        switch (selectedType) {
          case GotoType.page:
            isValid = _isPageNumberValid(inputNumber);
            break;
          case GotoType.paragraph:
            isValid = _isParagraphNumberValid(inputNumber);
            break;
        }
      }
    });
  }

  bool _isPageNumberValid(int pageNumber) {
    return widget.firstPage <= pageNumber && pageNumber <= widget.lastPage;
  }

  bool _isParagraphNumberValid(int paragraphNumber) {
    return widget.firstParagraph <= paragraphNumber &&
        paragraphNumber <= widget.lastParagraph;
  }
}
