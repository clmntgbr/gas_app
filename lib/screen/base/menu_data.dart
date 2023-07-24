import 'package:flutter/material.dart';

class MenuData {
  MenuData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<MenuData> tabIconsList = <MenuData>[
    MenuData(
      imagePath: 'assets/base/tab_3.png',
      selectedImagePath: 'assets/base/tab_3s.png',
      index: 0,
      isSelected: false,
      animationController: null,
    ),
    MenuData(
      imagePath: 'assets/base/tab_2.png',
      selectedImagePath: 'assets/base/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    MenuData(
      imagePath: 'assets/base/tab_1.png',
      selectedImagePath: 'assets/base/tab_1s.png',
      index: 2,
      isSelected: true,
      animationController: null,
    ),
    MenuData(
      imagePath: 'assets/base/tab_4.png',
      selectedImagePath: 'assets/base/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
