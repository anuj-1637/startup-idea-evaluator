import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../model/idea_model.dart';

class Theme_Mode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Idea_Model>(
      builder: (_, provider, __) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        decoration: BoxDecoration(
          color: provider.isdark ? Color(0xFF121212) : Color(0xFFF6F8FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: provider.isdark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Center(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color: provider.isdark
                            ? Colors.white
                            : Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: provider.isdark ? Color(0xFF1F1F1F) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  if (!provider.isdark)
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: provider.isdark
                        ? Colors.deepPurple
                        : Colors.grey[200],
                    child: Icon(
                      provider.isdark ? Icons.dark_mode : Icons.wb_sunny,
                      color: provider.isdark ? Colors.white : Colors.deepPurple,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: provider.isdark
                            ? Colors.white
                            : Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8.sp,
                    child: Switch.adaptive(
                      activeColor: Colors.deepPurple,
                      value: provider.isdark,
                      onChanged: (value) {
                        provider.updateTheme(value: value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
