import 'package:demo_project/app/features/home/view/home_screen.dart';
import 'package:demo_project/app/features/library/view/library_page.dart';
import 'package:demo_project/app/features/profile/view/profile_page.dart';
import 'package:demo_project/app/features/shop/view/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  int index = 0;

  List<Widget> pages = [HomeScreen(), LibraryPage(), ShopPage(), ProfilePage()];

  void changePage(int i) {
    index = i;
    update();
  }
}
