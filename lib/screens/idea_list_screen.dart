import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:startup_idea_evaluator/model/idea_model.dart';
import 'package:startup_idea_evaluator/screens/submit_idea_screen.dart';
import 'package:startup_idea_evaluator/screens/theme_mode.dart';
import 'package:startup_idea_evaluator/widgets/idea_card.dart';

class Idea_List_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Idea_List_Screen_State();
}

class Idea_List_Screen_State extends State<Idea_List_Screen> {
  String sortBy = 'Votes';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [Colors.black, Colors.grey[900]!]
                  : [Color(0xFF43C6AC), Color(0xFF191654)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            titleSpacing: 16.w,
            title: Text(
              '🚀 All Startup Ideas',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  dropdownColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.black,
                  icon: Icon(Icons.sort, color: Colors.white, size: 22.sp),
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                      context.read<Idea_Model>().sortListBy(sortBy);
                    });
                  },
                  items: ['Votes', 'Rating'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(
                        "Sort by $val",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      backgroundColor: isDark ? Colors.black : Color(0xFFF3F7F9),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [Color(0xFF0f2027), Color(0xFF203a43)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: IdeaCard(),
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SpeedDial(
          backgroundColor: isDark ? Color(0xFF0f3443) : Color(0xFF43C6AC),
          buttonSize: Size(52.w, 52.w),
          childrenButtonSize: Size(48.w, 48.w),
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          animatedIconTheme: IconThemeData(size: 26.sp),
          spacing: 14.h,
          spaceBetweenChildren: 12.h,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          children: [
            SpeedDialChild(
              child: Icon(Icons.add, color: Colors.white, size: 22.sp),
              backgroundColor: isDark ? Colors.teal[700] : Color(0xFF6dd5ed),
              label: "Submit Idea",
              labelStyle: TextStyle(fontSize: 14.sp),
              onTap: () => bottomsheet(),
            ),
            SpeedDialChild(
              child: Icon(Icons.settings, color: Colors.white, size: 22.sp),
              backgroundColor: isDark ? Colors.teal[900] : Color(0xFF2193b0),
              label: "Settings",
              labelStyle: TextStyle(fontSize: 14.sp),
              onTap: () => bottomsheet1(context),
            ),
          ],
        ),
      ),
    );
  }

  void bottomsheet() {
    showMaterialModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        child: Submit_Idea_Screen(),
      ),
    );
  }

  void bottomsheet1(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<Idea_Model>(
        builder: (_, provider, __) {
          return Container(
            height: 240.h,
            decoration: BoxDecoration(
              color: provider.isdark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
              border: Border(
                top: BorderSide(
                  color: provider.isdark ? Colors.white : Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            padding: EdgeInsets.all(20.w),
            child: Theme_Mode(),
          );
        },
      ),
    );
  }
}
