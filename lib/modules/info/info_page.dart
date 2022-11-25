import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../widgets/loading_view.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: Platform.isMacOS ? 18.0 : 0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        title: const Text('သိကောင်းစရာ'),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _loadInfoText(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingView();
          }
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              snapshot.data!,
              textStyle: const TextStyle(fontSize: 18.0),
            ),
          ));
        },
      ),
    );
  }

  Future<String> _loadInfoText() async {
    return await rootBundle.loadString('assets/info.html');
  }
}
