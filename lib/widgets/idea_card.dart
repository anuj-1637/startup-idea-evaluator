import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/idea_model.dart';

class IdeaCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IdeaCardState();
}

class IdeaCardState extends State<IdeaCard> {
  List<bool> isExpandedList = [];

  final List<List<Color>> lightModeGradients = [
    [Color(0xFF2193b0), Color(0xFF6dd5ed)],
    [Color(0xFF43C6AC), Color(0xFF191654)],
    [Color(0xFF11998e), Color(0xFF38ef7d)],
    [Color(0xFF134E5E), Color(0xFF71B280)],
    [Color(0xFF43C6AC), Color(0xFF191654)],
    [Color(0xFF56CCF2), Color(0xFF2F80ED)],
  ];

  final List<List<Color>> darkModeGradients = [
    [Color(0xFF232526), Color(0xFF414345)],
    [Color(0xFF141E30), Color(0xFF243B55)],
    [Color(0xFF1F1C2C), Color(0xFF928DAB)],
    [Color(0xFF373B44), Color(0xFF4286f4)],
    [Color(0xFF000000), Color(0xFF434343)],
    [Color(0xFFA8E063), Color(0xFF56AB2F)],
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<Idea_Model>(
      builder: (_, provider, __) {
        List myList = provider.myIdeaList;
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        if (isExpandedList.length != myList.length) {
          isExpandedList = List<bool>.filled(myList.length, false);
        }

        return myList.isEmpty
            ? Center(
                child: Text("No ideas yet", style: TextStyle(fontSize: 18.sp)),
              )
            : ListView.builder(
                itemCount: myList.length,
                itemBuilder: (context, index) {
                  final idea = myList[index];
                  final gradient = isDark
                      ? darkModeGradients[index % darkModeGradients.length]
                      : lightModeGradients[index % lightModeGradients.length];
                  return Dismissible(
                    key: Key(idea["key"].toString()),
                    onDismissed: (direction) {
                      provider.deleteItem(idea['key']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${idea['title']} deleted"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              idea['title'] ?? "",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "#${idea['tag'] ?? ""}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white70,
                              ),
                            ),

                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "⭐ Rating: ${idea['rating']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  "👍 Votes: ${idea['vote']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            if (isExpandedList[index])
                              Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  idea['description'],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpandedList[index] =
                                      !isExpandedList[index];
                                });
                              },
                              child: Text(
                                isExpandedList[index]
                                    ? "Read Less ▲"
                                    : "Read More ▼",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: idea['isVoted'] ?? false
                                      ? Colors.yellow
                                      : Colors.white70,
                                  size: 20.sp,
                                ),
                                onPressed: idea['isVoted'] ?? false
                                    ? null
                                    : () async {
                                        var updatedIdea =
                                            Map<String, dynamic>.from(idea);
                                        updatedIdea['isVoted'] = true;
                                        await provider.updateItem(
                                          idea['key'],
                                          updatedIdea,
                                        );
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
