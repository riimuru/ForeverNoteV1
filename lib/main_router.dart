import 'package:flutter/material.dart';
import 'routes/home.dart';
import 'routes/search.dart';
import 'routes/settings.dart';

class MainRouter extends StatelessWidget {
  const MainRouter();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: ListView(children: [
            SizedBox(
              height: size.height * 0.85,
              child: TabBarView(
                children: [
                  Home(),
                  Search(),
                  Settings(),
                ],
              )
            )
          ]),
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
                        icon: const Icon(Icons.star, size: 30.0),
                        height: size.height * 0.07),
                    Tab(
                        icon: const Icon(Icons.settings, size: 30.0),
                        height: size.height * 0.07),
                  ])),
        ));
  }
}
