

import 'package:pdf_render/pdf_render.dart';

class PdfInfo {
  PdfDocument document;
  int pageCount;
  int width;
  int height;
  PdfInfo(
    this.document,
    this.pageCount,
    this.width,
    this.height,
  );
}
