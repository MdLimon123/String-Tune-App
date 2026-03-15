import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const CustomAppbar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0F172A),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Center(child: Icon(Icons.arrow_back, color: Colors.white)),
            ),
          ),
          SizedBox(width: 50),
          Text(
            title ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
