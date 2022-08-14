import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

enum ColorMode { day, night, speia, grayscale }
Map<ColorMode, List<double>> _predefinedFilters = {
  ColorMode.day: [
    //R  G   B    A  Const
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ],
  ColorMode.grayscale: [
    //R  G   B    A  Const
    0.33, 0.59, 0.11, 0, 0, //
    0.33, 0.59, 0.11, 0, 0, //
    0.33, 0.59, 0.11, 0, 0, //
    0, 0, 0, 1, 0, //
  ],
  ColorMode.night: [
    //R  G   B    A  Const
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ],
  ColorMode.speia: [
    //R  G   B    A  Const
    0.393, 0.769, 0.189, 0, 0, //
    0.349, 0.686, 0.168, 0, 0, //
    0.172, 0.534, 0.131, 0, 0, //
    0, 0, 0, 1, 0, //
  ],
};

class MyPdfPageView extends StatelessWidget {
  const MyPdfPageView({
    Key? key,
    required this.pdfPageView,
    required this.colorMode,
  }) : super(key: key);

  final PdfPageView pdfPageView;
  final ColorMode colorMode;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(_predefinedFilters[colorMode]!),
      child: pdfPageView,
    );
  }
}
