import 'package:flutter/material.dart';

import '../favorites/favorites_screen.dart';
import '../map/map_screen.dart';
import 'bottom_bar_view.dart';
import 'menu_data.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<MenuData> tabIconsList = MenuData.tabIconsList;

  Widget tabBody = Container(
    color: const Color(0xFFF2F3F8),
  );

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MapScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F3F8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            return Stack(
              children: <Widget>[
                tabBody,
                bottomBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(
      const Duration(milliseconds: 200),
    );
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = FavoritesScreen(animationController: animationController);
            });
          },
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MapScreen(animationController: animationController);
                });
              });
            }

            if (index == 1 || index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MapScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
