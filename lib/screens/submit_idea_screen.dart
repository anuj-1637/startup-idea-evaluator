import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:startup_idea_evaluator/model/idea_model.dart';

class Submit_Idea_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Submit_Idea_Screen();
}

class _Submit_Idea_Screen extends State<Submit_Idea_Screen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    tagController.dispose();
    descriptionController.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close),
                ),
                SizedBox(width: 30.w),
                Text(
                  "Submit your idea",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                children: [
                  buildInputField(
                    context,
                    "idea title",
                    titleController,
                    focusNode1,
                    focusNode2,
                    "Enter your idea title",
                  ),
                  SizedBox(height: 20.h),
                  buildInputField(
                    context,
                    "Idea tag",
                    tagController,
                    focusNode2,
                    focusNode3,
                    "Enter your idea tag",
                  ),
                  SizedBox(height: 20.h),
                  buildDescriptionField(
                    descriptionController,
                    focusNode3,
                    context,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    // height: 40.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[100],
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        submitIdea();
                        // Get.back();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitIdea() {
    if (titleController.text.trim().isEmpty ||
        tagController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields before submitting",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );
      return;
    }
    var rating = context.read<Idea_Model>().generateRandomRating();
    var vote = context.read<Idea_Model>().generateRandomVote();
    Map m = {
      "title": titleController.text,
      "tag": tagController.text,
      "description": descriptionController.text,
      "rating": rating,
      "vote": vote,
    };
    context.read<Idea_Model>().addData(m);
    Get.snackbar(
      "Success",
      "Idea submitted successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: EdgeInsets.all(12),
      borderRadius: 10,
      duration: Duration(milliseconds: 1500),
    );
    Navigator.pop(context);
  }
}

Widget buildInputField(
  BuildContext context,
  String label,
  TextEditingController controller,
  FocusNode currentFocus,
  FocusNode nextFocus,
  String hintText,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return TextField(
    controller: controller,
    focusNode: currentFocus,
    onSubmitted: (_) => FocusScope.of(context).requestFocus(nextFocus),
    style: TextStyle(
      fontSize: 14.sp,
      color: isDark ? Colors.white : Colors.black,
    ),
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 13.sp),
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
    ),
  );
}

Widget buildDescriptionField(
  TextEditingController controller,
  FocusNode focusNode,
  BuildContext context,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return TextField(
    controller: controller,
    focusNode: focusNode,
    onSubmitted: (_) => focusNode.unfocus(),
    minLines: 1,
    maxLines: null,
    style: TextStyle(
      fontSize: 14.sp,
      color: isDark ? Colors.white : Colors.black,
    ),
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelText: 'Idea Description',
      hintText: "Enter your description here",
      hintStyle: TextStyle(fontSize: 13.sp),
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
      alignLabelWithHint: true,
    ),
  );
}
