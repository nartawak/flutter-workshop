import 'package:flutter/material.dart';

class PullToRefreshRoute extends StatelessWidget {
  List<Container> _createListChildren() {
    return List.filled(
      8,
      Container(
        height: 100,
        margin: EdgeInsets.only(
          bottom: 30,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9D8B),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF99CD),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(
          const Duration(seconds: 3),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            ..._createListChildren(),
          ],
          padding: EdgeInsets.symmetric(
            horizontal: 50,
          ),
        ),
      ),
    );
  }
}
