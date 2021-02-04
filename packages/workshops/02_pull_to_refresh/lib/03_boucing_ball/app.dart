import 'package:flutter/material.dart';
import 'package:pull_to_refresh/03_boucing_ball/routes/pull_to_refresh_route.dart';

class PullToRefreshApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PullToRefreshRoute(),
    );
  }
}
