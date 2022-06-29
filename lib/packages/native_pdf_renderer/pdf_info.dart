
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

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
