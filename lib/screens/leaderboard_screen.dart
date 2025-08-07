import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/idea_model.dart';

class Leaderboard_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topIdeas = context.watch<Idea_Model>().topIdeas;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundGradient = LinearGradient(
      colors: isDark
          ? [Color(0xFF0F2027), Color(0xFF2C5364)]
          : [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final cardColor = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.white.withOpacity(0.88);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "🏆 Leaderboard",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: topIdeas.length,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          itemBuilder: (context, index) {
            final idea = topIdeas[index];

            // 🏅 Determine trailing widget based on rank
            Widget trailingWidget;
            if (index == 0) {
              trailingWidget = Text(
                "🥇",
                style: TextStyle(fontSize: 24.sp, color: Colors.amber),
              );
            } else if (index == 1) {
              trailingWidget = Text(
                "🥈",
                style: TextStyle(fontSize: 24.sp, color: Colors.grey[300]),
              );
            } else if (index == 2) {
              trailingWidget = Text(
                "🥉",
                style: TextStyle(fontSize: 24.sp, color: Colors.brown[300]),
              );
            } else if (index == 3 || index == 4) {
              trailingWidget = Icon(
                Icons.star_border_rounded,
                size: 26.sp,
                color: isDark ? Colors.white70 : Colors.deepPurple,
              );
            } else {
              trailingWidget = SizedBox.shrink(); // Nothing
            }

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.grey.withOpacity(0.15),
                    blurRadius: 12.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 14.h,
                ),
                leading: CircleAvatar(
                  radius: 22.r,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.deepPurple.withOpacity(0.1),
                  child: Text(
                    "#${index + 1}",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                title: Text(
                  idea['title'],
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  "Votes: ${idea['vote']}",
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                trailing: trailingWidget,
              ),
            );
          },
        ),
      ),
    );
  }
}
