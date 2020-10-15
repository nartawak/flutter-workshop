import 'package:flutter/material.dart';

class MasterRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Master route'),
      ),
    );
  }
}
