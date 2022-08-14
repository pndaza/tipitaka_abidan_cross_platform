import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

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

class PdfPageView extends StatelessWidget {
  final PdfDocument pdfDocument;
  final int pageNumber;
  final ColorMode colorMode;
  const PdfPageView({
    Key? key,
    required this.pdfDocument,
    required this.pageNumber,
    required this.colorMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return FutureBuilder<PdfPage>(
          future: pdfDocument.getPage(pageNumber),
          builder: (context, snapShot) {
            if (!snapShot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final PdfPage pdfPage = snapShot.data!;
            final scaleFactor =
                _getScaleFactor(width: pdfPage.width, widthToRender: 2100);

            return FutureBuilder<PdfPageImage?>(
                future: pdfPage.render(
                  width: (pdfPage.width * scaleFactor).floor(),
                  height: (pdfPage.height * scaleFactor).floor(),
                ),
                builder: (context, snapShot) {
                  if (!snapShot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapShot.data == null) {
                    return const Center(
                      child: Text('something wrong'),
                    );
                  }
                  final PdfPageImage pdfPageImage = snapShot.data!;
                  return ColorFiltered(
                    colorFilter:
                        ColorFilter.matrix(_predefinedFilters[colorMode]!),
                    child: Image(
                      fit: BoxFit.contain,
                      image: MemoryImage(pdfPageImage.bytes),
                    ),
                  );
                });
          });
    });
  }
/*
  void _loadPageImage(double maxWidth) async {
    final pdfPage = await pdfDocument.getPage(pageNumber);
    final scaleFactor =
        _getScaleFactor(width: pdfPage.width, widthToRender: maxWidth);
    final pdfImage = await pdfPage.render(
        width: (pdfPage.width * scaleFactor).floor(),
        height: (pdfPage.height * scaleFactor).floor());
    pdfPage.close();
  }
*/

  double _getScaleFactor({required int width, required double widthToRender}) =>
      double.parse((widthToRender / width).toStringAsFixed(2));
}
