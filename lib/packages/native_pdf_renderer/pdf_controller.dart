import 'package:flutter/material.dart';

class PdfController {
  PdfController({required this.intialPage});
  final int intialPage;

  PageController? _pageController;

  void attachController(PageController pageController) {
    _pageController = pageController;
  }

  void gotoPage(int pageNumber) {
    _pageController?.jumpToPage(pageNumber - 1);
  }
}
