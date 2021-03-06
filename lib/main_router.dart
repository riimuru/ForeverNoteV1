import 'package:flutter/material.dart';
import 'routes/home.dart';
import 'routes/search.dart';
import 'routes/settings.dart';
import 'provider/theme_provider.dart';
import 'package:provider/provider.dart';

class MainRouter extends StatelessWidget {
  const MainRouter();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SizedBox(
              height: size.height * 1,
              child: TabBarView(
                children: [
                  Home(),
                  Search(),
                  Settings(),
                ],
              )),
          bottomNavigationBar: Material(
              color: Colors.yellowAccent[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: TabBar(
                  unselectedLabelColor: Colors.pinkAccent[400],
                  labelColor: Colors.black,
                  indicatorColor: Colors.transparent,
                  //TODO: add button enlargement on click
                  tabs: <Widget>[
                    Tab(
                        icon: const Icon(Icons.home, size: 30.0),
                        height: size.height * 0.07),
                    Tab(
                        icon: const Icon(Icons.blur_on, size: 30.0),
                        height: size.height * 0.07),
                    Tab(
                        icon: const Icon(Icons.settings, size: 30.0),
                        height: size.height * 0.07),
                  ])),
        ));
  }
}
