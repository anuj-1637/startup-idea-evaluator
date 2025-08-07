import 'package:animations/animations.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:startup_idea_evaluator/model/idea_model.dart';
import 'package:startup_idea_evaluator/screens/idea_list_screen.dart';
import 'package:startup_idea_evaluator/screens/leaderboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("ideaBox");
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 640),
      minTextAdapt: true,
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Idea_Model(ideaBox: Hive.box('ideaBox')),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Idea',
      themeMode: context.watch<Idea_Model>().isdark
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> screens = [Idea_List_Screen(), Leaderboard_Screen()];
  int index = 0;

  void initState() {
    super.initState();
    Hive.box("ideaBox");
    context.read<Idea_Model>().initialState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: (child, animation, secondaryAnimation) =>
            FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
        child: screens[index],
      ),
      bottomNavigationBar: BottomBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.grey[200],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        height: 55.h,
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        selectedIndex: index,
        items: [
          BottomBarItem(
            inactiveIcon: Icon(Icons.home, size: 22.sp),
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
              size: 24.sp,
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            title: Text("Idea List", style: TextStyle(fontSize: 14.sp)),
          ),
          BottomBarItem(
            inactiveIcon: Icon(Icons.leaderboard_outlined, size: 22.sp),
            icon: Icon(
              Icons.leaderboard,
              color: Theme.of(context).colorScheme.primary,
              size: 24.sp,
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            title: Text("Leaderboard", style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}
